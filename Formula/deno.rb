class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.26.2/deno_src.tar.gz"
  sha256 "69dcc7ea1e52a209c5fd386341e37b3c93b3e12f62fe645bf5bdd04cc8c86689"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "024c6213f11123395878c59a9893ee0a13e43ead7394cf51179f74e2b6c559f3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c52e74a1068cb3d391fff121c71b025d3b0eae6e3c9330139f21d325a35c05d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15237b1c18b293aae03c5c4c041837bda227d61fcce35f4f94604f0fe2cd8ff9"
    sha256 cellar: :any_skip_relocation, monterey:       "23bbfb385b7c070b8fb43288c31accfa80c820181e373f79d2be7fb8c25987f4"
    sha256 cellar: :any_skip_relocation, big_sur:        "97ac726cf5b9268f39bd288e42ce6a6677712fc77582872669835f6d4f51e1b6"
    sha256 cellar: :any_skip_relocation, catalina:       "a9bc4b28bde6ee84926ea162124654bea7fa574c1d91c9b0749be4a0ff4987e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6bf56d69c42cab9d9a9020a87342e4926084b71a2be648264a56b772e815a132"
  end

  depends_on "llvm" => :build
  depends_on "ninja" => :build
  depends_on "python@3.10" => :build
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
  # TODO: Remove this and `v8` resource when https://github.com/denoland/rusty_v8/pull/1063 is released
  resource "rusty-v8" do
    url "https://static.crates.io/crates/v8/v8-0.53.1.crate"
    sha256 "e952e936bcb610c9f22997f50dc7f65887afe76e1fedd37daf532a20211335ca"
  end

  resource "v8" do
    url "https://github.com/denoland/v8/archive/b948377e7ee0948e0111ffc724989f8017567584.tar.gz"
    sha256 "1a562b9e21e9d9381ecc6fdcb17ece279b530e69c430d5204401152dc70756d7"
  end

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/core/Cargo.toml
  # 2. Find ninja_gn_binaries tag: https://github.com/denoland/rusty_v8/tree/v#{v8_version}/tools/ninja_gn_binaries.py
  # 3. Find short gn commit hash from commit message: https://github.com/denoland/ninja_gn_binaries/tree/#{ninja_gn_binaries_tag}
  # 4. Find full gn commit hash: https://gn.googlesource.com/gn.git/+/#{gn_commit}
  resource "gn" do
    url "https://gn.googlesource.com/gn.git",
        revision: "bf4e17dc67b2a2007475415e3f9e1d1cf32f6e35"
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
    inreplace %w[core/Cargo.toml serde_v8/Cargo.toml],
              /^v8 = { version = ("[\d.]+"),.*}$/,
              "v8 = { version = \\1, path = \"../v8\" }"

    if OS.mac? && (MacOS.version < :mojave)
      # Overwrite Chromium minimum SDK version of 10.15
      ENV["FORCE_MAC_SDK_MIN"] = MacOS.version
    end

    python3 = "python3.10"
    # env args for building a release build with our python3, ninja and gn
    ENV.prepend_path "PATH", Formula["python@3.10"].libexec/"bin"
    ENV["PYTHON"] = Formula["python@3.10"].opt_bin/python3
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
