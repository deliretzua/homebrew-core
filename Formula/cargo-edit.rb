class CargoEdit < Formula
  desc "Utility for managing cargo dependencies from the command-line"
  homepage "https://killercup.github.io/cargo-edit/"
  url "https://github.com/killercup/cargo-edit/archive/v0.11.9.tar.gz"
  sha256 "46670295e2323fc2f826750cdcfb2692fbdbea87122fe530a07c50c8dba1d3d7"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d0f0e80915118ac4f68d9480c847da8c6232bc8aa159ab99730f4393aa62398a"
    sha256 cellar: :any,                 arm64_monterey: "cfc42d301f4868eb1e16436f717876e14f93f69ce87aeb3b00a6be90c3fdf4bf"
    sha256 cellar: :any,                 arm64_big_sur:  "9c142f7dda50023824f5be76ecbe25e02ea5bfd0a7708bcc4f221be568984a57"
    sha256 cellar: :any,                 ventura:        "c6c73db9a959d24e68a88cdac53ab246149d8bc7c9e6aa4018da132bd9d008a7"
    sha256 cellar: :any,                 monterey:       "43a854c7b69f2e028fc786962849e26c5dbab9cadf36472bb326d0b05e6bfa29"
    sha256 cellar: :any,                 big_sur:        "c0ac725185acda284bce3e79c1eb9ff361aa25c2570f22899f339a917cc2d42d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "369459c3c1c778113fb1e17b9ede22ae43d0faef13cc73f6cb21413a89af766d"
  end

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust" # uses `cargo` at runtime

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"src/main.rs").write "// Dummy file"
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [dependencies]
        clap = "2"
      EOS

      system bin/"cargo-set-version", "set-version", "0.2.0"
      assert_match 'version = "0.2.0"', (crate/"Cargo.toml").read

      system bin/"cargo-rm", "rm", "clap"
      refute_match(/clap/, (crate/"Cargo.toml").read)
    end
  end
end
