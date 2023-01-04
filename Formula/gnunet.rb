class Gnunet < Formula
  desc "Framework for distributed, secure and privacy-preserving applications"
  homepage "https://gnunet.org/"
  url "https://ftp.gnu.org/gnu/gnunet/gnunet-0.17.5.tar.gz"
  mirror "https://ftpmirror.gnu.org/gnunet/gnunet-0.17.5.tar.gz"
  sha256 "8a744ff7a95d1e83215cce118050640f6c12261abe4c60a56bcf88e500f0023d"
  license "AGPL-3.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a91a4ae5c45bb5304fd032f2d02368e6f5c769cfbba1ea5669e8e8e4807bc87b"
    sha256 cellar: :any,                 arm64_monterey: "b0a6fdd5c5f7b50db8edb9b1390c5c2cf310e275cb71537c2739e78d1ee8b41e"
    sha256 cellar: :any,                 arm64_big_sur:  "0f7cc35b0a1e867d4ff39ce79ac947b1f5aba462e27ca568c516d41e20bed7f3"
    sha256 cellar: :any,                 ventura:        "1c7ffa62a85d1369f2652f31e4cf69cc937034de7e46d4a6c391a9a7d2eb1c6d"
    sha256 cellar: :any,                 monterey:       "0b1d3996e330a582be35410cdf6d1656ab9b94545047486fe5d27d64d91ec850"
    sha256 cellar: :any,                 big_sur:        "327fd66c7bc476112f7a11c6d7ab9872ca7b6ce85765fa5ad045c32280b690f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa2caa63b0612e0c697d73bdf72feb228ede99c75c75aa284c8606080f329716"
  end

  # macOS `ld64` does not like the `.la` files created during the build.
  depends_on "llvm" => :build if DevelopmentTools.clang_build_version >= 1400
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gnutls"
  depends_on "jansson"
  depends_on "libextractor"
  depends_on "libgcrypt"
  depends_on "libidn2"
  depends_on "libmicrohttpd"
  depends_on "libsodium"
  depends_on "libunistring"

  uses_from_macos "curl"
  uses_from_macos "sqlite"

  def install
    ENV.deparallelize if OS.linux?
    # Workaround for Xcode 14 ld until Makefile is fixed
    # Ref: https://github.com/Homebrew/homebrew-core/pull/113789#issuecomment-1288125182
    ENV.append_to_cflags "-fuse-ld=lld" if DevelopmentTools.clang_build_version >= 1400
    system "./configure", *std_configure_args, "--disable-documentation"
    system "make", "install"
  end

  test do
    system "#{bin}/gnunet-config", "--rewrite"
    output = shell_output("#{bin}/gnunet-config -s arm")
    assert_match "BINARY = gnunet-service-arm", output
  end
end
