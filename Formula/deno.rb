class Deno < Formula
  desc "Secure runtime for JavaScript and TypeScript"
  homepage "https://deno.land/"
  url "https://github.com/denoland/deno/releases/download/v1.30.2/deno_src.tar.gz"
  sha256 "8cdd7ed74da462895432b888659930202eeeecc3ade3464ea1c844737d1301a6"
  license "MIT"
  head "https://github.com/denoland/deno.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b8b892dd7e25e3c28b1513c72da5b1d6ed4d0360acdd2a7858d21246f1f2b67a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b797d3c38b7024d91d6f6206be94d160ece2a8287a8a07701530126221ff0fc1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b657812dd9f48c48728187c209c1930c5fe46ee72a51d5be9c5531caa59a586"
    sha256 cellar: :any_skip_relocation, ventura:        "792f33adaf64c283bebcd4aacb7475d960ac5569d7d1cdc74c5badd06dac8450"
    sha256 cellar: :any_skip_relocation, monterey:       "0738ce0b5a93cd5996c8aa912e19444262918d641015513fbf2f0cd6958e9b25"
    sha256 cellar: :any_skip_relocation, big_sur:        "0388f3dcfca92664bc6c72b9e8bd53c18666809955191164f69b46961605e70f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ba4f5c68258a7fb5ba11f0935af84c9d68ddd5f6f9ad383152fbbae98a2e738"
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
  # TODO: Remove this and `v8` resource when https://github.com/denoland/rusty_v8/pull/1063 is released
  resource "rusty-v8" do
    url "https://static.crates.io/crates/v8/v8-0.60.1.crate"
    sha256 "07fd5b3ed559897ff02c0f62bc0a5f300bfe79bb4c77a50031b8df771701c628"
  end

  resource "v8" do
    url "https://github.com/denoland/v8/archive/05fb6e97fc6c5fdd2e79e4f9a51c5bf0ca0ef991.tar.gz"
    sha256 "a083d815b21b0a2a59d1f133fd897c1f803f1418cfdffd411a89583bf37f22a8"
  end

  # To find the version of gn used:
  # 1. Find v8 version: https://github.com/denoland/deno/blob/v#{version}/Cargo.toml#L43
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
