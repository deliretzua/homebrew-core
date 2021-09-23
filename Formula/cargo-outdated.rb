class CargoOutdated < Formula
  desc "Cargo subcommand for displaying when Rust dependencies are out of date"
  homepage "https://github.com/kbknapp/cargo-outdated"
  url "https://github.com/kbknapp/cargo-outdated/archive/v0.9.17.tar.gz"
  sha256 "9311409ce07bad0883439fdba4bfb160e8d0c7a63d84e45dc0c71fbeb5ac673a"
  license "MIT"
  revision 1
  head "https://github.com/kbknapp/cargo-outdated.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "7a5aac375755c44c21e36311cc6d3cb1cf352e71ae22ce2afd2fec244c57982a"
    sha256 cellar: :any, big_sur:       "b0db95e838d5e83b02bcf88ec6eb6f0aa5c9b2f04c2fa61dcc0e9b1b43debf48"
    sha256 cellar: :any, catalina:      "ffe12a04cc121da85c970e5c427cd00017f2901faca3690322ed925a15b5a542"
    sha256 cellar: :any, mojave:        "cbffce2d37bc58ece7635a8a04a815282277d5775166e26c2f6d45e4d17e239b"
  end

  depends_on "libgit2"
  depends_on "openssl@1.1"
  depends_on "rust"

  # Update `libgit2-sys` crate for Libgit2 1.2.0 support
  # https://github.com/kbknapp/cargo-outdated/issues/279
  patch :DATA

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    crate = testpath/"demo-crate"
    mkdir crate do
      (crate/"Cargo.toml").write <<~EOS
        [package]
        name = "demo-crate"
        version = "0.1.0"

        [lib]
        path = "lib.rs"

        [dependencies]
        libc = "0.1"
      EOS

      (crate/"lib.rs").write "use libc;"

      output = shell_output("cargo outdated 2>&1")
      # libc 0.1 is outdated
      assert_match "libc", output
    end
  end
end

__END__
diff --git a/Cargo.lock b/Cargo.lock
index 6302b41..06ef1ce 100644
--- a/Cargo.lock
+++ b/Cargo.lock
@@ -591,9 +591,9 @@ checksum = "8916b1f6ca17130ec6568feccee27c156ad12037880833a3b842a823236502e7"
 
 [[package]]
 name = "libgit2-sys"
-version = "0.12.18+1.1.0"
+version = "0.12.23+1.2.0"
 source = "registry+https://github.com/rust-lang/crates.io-index"
-checksum = "3da6a42da88fc37ee1ecda212ffa254c25713532980005d5f7c0b0fbe7e6e885"
+checksum = "29730a445bae719db3107078b46808cc45a5b7a6bae3f31272923af969453356"
 dependencies = [
  "cc",
  "libc",
