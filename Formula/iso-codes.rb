class IsoCodes < Formula
  desc "Provides lists of various ISO standards"
  homepage "https://salsa.debian.org/iso-codes-team/iso-codes"
  url "https://deb.debian.org/debian/pool/main/i/iso-codes/iso-codes_4.6.0.orig.tar.xz"
  sha256 "41c672c18554e979e6191f950f454cdf1bfb67a6369fffe2997ff68e34845409"
  license "LGPL-2.1-or-later"
  head "https://salsa.debian.org/iso-codes-team/iso-codes.git"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "31ff556939a9d57214d7ad44c1d842d23dfdb3908994a286681df2a8c1dbd46d"
    sha256 cellar: :any_skip_relocation, big_sur:       "118b191fb44a9620d8c0c354f8ac922792d3e75d54bc39ca1510be016c3a2d92"
    sha256 cellar: :any_skip_relocation, catalina:      "7188c8c30f91805fb9a57fdb2724372e3c322df32cf429b9aa83947a1fda06be"
    sha256 cellar: :any_skip_relocation, mojave:        "976ba22be91927b7b3ef72c657b642b3b2c29c78d9c8ae2ce427ffd10fdca830"
    sha256 cellar: :any_skip_relocation, high_sierra:   "eae28b543407ce32653a9c6611f89c6d7fafee8adbd84e76f4785ec962d5bcd0"
  end

  depends_on "gettext" => :build
  depends_on "python@3.9" => :build

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    output = shell_output("grep domains #{share}/pkgconfig/iso-codes.pc")
    assert_match "iso_639-2 iso_639-3 iso_639-5 iso_3166-1", output
  end
end
