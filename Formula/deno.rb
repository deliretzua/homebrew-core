class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.20.4/deno_src.tar.gz"
  sha256 "921aff769d9e54e30a33fb80dfe6db5b9bfc464cfc041083d9f17a78662bd1ac"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9882369f75163eb4fac70e03b0c7c328dec02dc51a070456469994698a84a698"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b9f8d1f324fe41c3843ad9a7ccca62437118faf616402a88a2b2af595d911b81"
    sha256 cellar: :any_skip_relocation, monterey:       "37d32d63380b520c1c6c48a975071782e2eb31c5798cc8c5a872bef87769d350"
    sha256 cellar: :any_skip_relocation, big_sur:        "d557322cda4e9cecff0841fdb785cc603b812ab82cd1ebdb609a49846cb8a4d1"
    sha256 cellar: :any_skip_relocation, catalina:       "f084a86cefc14e99eebfb5bac8d98556978650c8dad6fb44b2a0329d5ca629fc"
    sha256                               x86_64_linux:   "9383140525d732df705bd4800433b5c1cdcf2e637928c98fe3e3b2709aa3fe8f"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.9" => :build
  depends_on "rust" => :build

  uses_from_macos "xz"

  on_macos do
    depends_on xcode: ["10.0", :build] # required by v8 7.9+
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gcc"
    depends_on "glib"
  end

  fails_with gcc: "5"

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/core/Cargo.toml
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/tree/v#{v8_version}/tools/ninja_gn_binaries.py
  # 3. Find short gn commit hash from commit message: https://github.com/denoland/ninja_gn_binaries/tree/#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https://gn.googlesource.com/gn.git/+/#{gn_commit}
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "53d92014bf94c3893886470a1c7c1289f8818db0"
  end

  def install
    if OS.mac? && (MacOS.version < :mojave)
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version
    end

    # env args for building a release build with our python3, ninja and gn
    ENV.prepend_path "PATH", Formula["python@3.9"].libexec/"bin"
    ENV["PYTHON"] = Formula["python@3.9"].opt_bin/"python3"
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix
    ENV.remove "HOMEBREW_LIBRARY_PATHS", Formula["llvm"].opt_lib

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system "python3", "build/gen.py"
      system "ninja", "-C", "out"
    end

    cd "cli" do
      # cargo seems to build rusty_v8 twice in parallel, which causes problems,
      # hence the need for -j1
      system "cargo", "install", "-vv", "-j1", *std_cargo_args
    end

    bash_output = Utils.safe_popen_read(bin/"deno", "completions", "bash")
    (bash_completion/"deno").write bash_output
    zsh_output = Utils.safe_popen_read(bin/"deno", "completions", "zsh")
    (zsh_completion/"_deno").write zsh_output
    fish_output = Utils.safe_popen_read(bin/"deno", "completions", "fish")
    (fish_completion/"deno.fish").write fish_output
  end

  test do
    (testpath/"hello.ts").write <<~EOS
      console.log("hello", "deno");
    EOS
    assert_match "hello deno", shell_output("#{bin}/deno run hello.ts")
    assert_match "console.log",
      shell_output("#{bin}/deno run --allow-read=#{testpath} https://deno.land/std@0.50.0/examples/cat.ts " \
                   "#{testpath}/hello.ts")
  end
end
