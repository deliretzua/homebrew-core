class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.12.tar.gz"
  sha256 "03dda8653367501b7b1188a6b6513416902372e27475553de9318ee89ac390ff"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cd50e25d3321c930d2ae3347c7af57dd44663ea7548969ac8ca5bdbe03511ab3"
    sha256 cellar: :any,                 arm64_monterey: "1c12c644963be477bcba9df308b577dd8dc23f4dc030827f374a299aceca501a"
    sha256 cellar: :any,                 arm64_big_sur:  "3835261ec2d775b4bf988d2bcd47f462e6f45eb6f88e4bea4ddee85312a5ff4e"
    sha256 cellar: :any,                 ventura:        "3e338adbcbe1fa2ce3c87b334a3dbddba29c049ba80d165470dff9d8e3536cbd"
    sha256 cellar: :any,                 monterey:       "4d5e9edd4943763e64157e06dad629b65aea3c1037bf7a619335b5bee3eb97fc"
    sha256 cellar: :any,                 big_sur:        "82ec35a1bac257ba0e38ef9deaf6f015113435b9ba521b39ac4764358bf4ea15"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "83e13fc866956618838b3e9aa5c1f16d574586c0d082a321c5e5c56a1ca62b1b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@1.1"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/localinfo"
    system "#{bin}/sip-date"
  end
end
