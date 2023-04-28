class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.33.1/deno_src.tar.gz"
  sha256 "e48cdaa3438f810479f82f46f9fa27f16b4364e33c4aebd48f8b58ee95187227"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8a90d989bfa121c81e24c09868c0dbb2cd1da98b4b43d36c0a5d1a91cd0a41ad"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3db9266270cba9fd312d720b0f034d52ee9d8c1aa1d5faa9f55fbcba41317ed"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ff2bfa13bcae1608e75f16591500ac553819afddf821a678fc2041f6c3cf4bd"
    sha256 cellar: :any_skip_relocation, ventura:        "a394eb021c21b8f4a9b3c2b20de5533a39f1aaf123b10efee2ba6c191f2469e6"
    sha256 cellar: :any_skip_relocation, monterey:       "291ecc11b1d3f34cf0e51a139ce9bf5a933d554b3a2c792984561be623dcb2ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0c89047f41224370b694d80ee94b8394d481d448219c22961b11d3587616201"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09938aa762e524c59b78de6695a909cfcc2e22bf318252202276a28f33a8da0a"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.11" => :build
  depends_on "rust" => :build

  uses_from_macos "xz"

  on_macos do
    depends_on xcode: ["10.0", :build] # required by v8 7.9+
  end

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "glib"
  end

  fails_with gcc: "5"

  # Temporary resources to work around build failure due to files missing from crate
  # We use the crate as GitHub tarball lacks submodules and this allows us to avoid git overhead.
  # TODO: Remove this and `v8` resource when https://github.com/denoland/rusty_v8/issues/1065 is resolved
  resource "rusty-v8" do
    url "https://static.crates.io/crates/v8/v8-0.71.0.crate"
    sha256 "51a173a437bebab13d587a4aaf0a1e7a49433226538c9a78ca3b4ce3b8c6aeb6"
  end

  # Use the latest tagged revision in https://github.com/denoland/v8/tags.
  resource "v8" do
    url "https://github.com/denoland/v8/archive/09b1430e7090eb1d3f1397276221c4e92403de57.tar.gz"
    sha256 "991cc00f37d037d69ca38716f04522f0bb261e67bbc7adf9b224266a93b62df2"
  end

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/Cargo.toml#L44
  #    1.1. Update `rusty-v8` resource to use this version.
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/blob/v#{v8_version}/tools/ninja_gn_binaries.py#L21
  # 3. Find short gn commit hash from commit message: https://github.com/denoland/ninja_gn_binaries/tree/#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https://gn.googlesource.com/gn.git/+/#{gn_commit}
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "70d6c60823c0233a0f35eccc25b2b640d2980bdc"
  end

  def install
    # Work around files missing from crate
    # TODO: Remove this at the same time as `rusty-v8` + `v8` resources
    (buildpath/"v8").mkpath
    resource("rusty-v8").stage do |r|
      system "tar", "--strip-components", "1", "-xzvf", "v8-#{r.version}.crate", "-C", buildpath/"v8"
    end
    resource("v8").stage do
      cp_r "tools/builtins-pgo", buildpath/"v8/v8/tools/builtins-pgo"
    end
    inreplace "Cargo.toml",
              /^v8 = { version = ("[\d.]+"),.*}$/,
              "v8 = { version = \\1, path = \"./v8\" }"

    if OS.mac? && (MacOS.version < :mojave)
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version
    end

    python3 = "python3.11"
    # env args for building a release build with our python3, ninja and gn
    ENV.prepend_path "PATH", Formula["python@3.11"].libexec/"bin"
    ENV["PYTHON"] = Formula["python@3.11"].opt_bin/python3
    ENV["GN"] = buildpath/"gn/out/gn"
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"
    # build rusty_v8 from source
    ENV["V8_FROM_SOURCE"] = "1"
    # Build with llvm and link against system libc++ (no runtime dep)
    ENV["CLANG_BASE_PATH"] = Formula["llvm"].prefix

    resource("gn").stage buildpath/"gn"
    cd "gn" do
      system python3, "build/gen.py"
      system "ninja", "-C", "out"
    end

    # cargo seems to build rusty_v8 twice in parallel, which causes problems,
    # hence the need for -j1
    # Issue ref: https://github.com/denoland/deno/issues/9244
    system "cargo", "install", "-vv", "-j1", *std_cargo_args(path: "cli")

    generate_completions_from_executable(bin/"deno", "completions")
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
