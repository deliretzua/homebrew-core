class Utftex < Formula
  desc "Pretty print math in monospace fonts, using a TeX-like syntax"
  homepage "https://github.com/bartp5/libtexprintf"
  url "https://github.com/bartp5/libtexprintf/archive/refs/tags/v1.23.tar.gz"
  sha256 "44f4ca8bf2aaaa6a904b10ed4b9c0f86d20d10463e3b38c99fa63a81cb16ebf5"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c564e3a11a86b80e3fa891641cbd689a9ad5982c75b69026e6154bee9db87275"
    sha256 cellar: :any,                 arm64_monterey: "efba72dbbee7da23c0543c8f6786dbead27d87ca081fc02c0aeddf1eddb66173"
    sha256 cellar: :any,                 arm64_big_sur:  "8c4c697906f5f4a6a648977313701a42d5a0e7cfc754d95f65f4c1da9f8d291c"
    sha256 cellar: :any,                 ventura:        "a384d43a9ee9b849930962988c0d5cae4f36a993e319b57ce8e01086d6e237db"
    sha256 cellar: :any,                 monterey:       "dd3701fa631dd05232525a4e5d5117c55c1372a3bd3de7874acf278a4df6fdb1"
    sha256 cellar: :any,                 big_sur:        "c4c4f644188ad9d962bc56d62f5d063a85157b4b6358100327896ed64f053745"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "679fa1d838c77ab98fe47976572e897ac39235bf141479afbbcd4c922771e983"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"utftex", "\\left(\\frac{hello}{world}\\right)"
  end
end
