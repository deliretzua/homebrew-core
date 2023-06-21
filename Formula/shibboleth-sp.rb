class ShibbolethSp < Formula
  desc "Shibboleth 2 Service Provider daemon"
  homepage "https://wiki.shibboleth.net/confluence/display/SHIB2"
  url "https://shibboleth.net/downloads/service-provider/3.4.1/shibboleth-sp-3.4.1.tar.bz2"
  sha256 "bffe3e62e46d86cc75db1093b77fa1456b30da7c930a13708afa0139c8a8acc1"
  license "Apache-2.0"
  revision 1

  livecheck do
    url "https://shibboleth.net/downloads/service-provider/latest/"
    regex(/href=.*?shibboleth-sp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c20a5c7713e6c9df6943e0fc44381ad2e121d88c6520f3db575b50e216140527"
    sha256 arm64_monterey: "56edfa751a11c7823491c0bef76892b5e18c69d756b445c5c7af935c3291b6ee"
    sha256 arm64_big_sur:  "ba56fb55b135e4fdd600a1a6077cdea118d6a2849258263d54f59edb619b6833"
    sha256 ventura:        "25792b0707c007a1af793251a2bc9ec029606e08a1a304cff5733135b6aa8ac3"
    sha256 monterey:       "39e2711adad28abcd94f2ce1edcfe5d0bfa24df973a79e67fa042b288e013117"
    sha256 big_sur:        "e5235e48a5aad3c29857a866bf9111f6d418bb78b724caa3560e48b87325055e"
    sha256 x86_64_linux:   "428a73d45d013e66cc9576ca59d1d2dfacbbafa468abfec3bc42fc9a3db56f69"
  end

  depends_on "apr" => :build
  depends_on "apr-util" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "httpd"
  depends_on "log4shib"
  depends_on "opensaml"
  depends_on "openssl@3"
  depends_on "unixodbc"
  depends_on "xerces-c"
  depends_on "xml-security-c"
  depends_on "xml-tooling-c"

  def install
    ENV.cxx11
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --localstatedir=#{var}
      --sysconfdir=#{etc}
      --with-xmltooling=#{Formula["xml-tooling-c"].opt_prefix}
      --with-saml=#{Formula["opensaml"].opt_prefix}
      --enable-apache-24
      --with-apxs24=#{Formula["httpd"].opt_bin}/apxs
      DYLD_LIBRARY_PATH=#{lib}
    ]

    system "./configure", *args
    system "make", "install"
  end

  def post_install
    (var/"run/shibboleth/").mkpath
    (var/"cache/shibboleth").mkpath
  end

  service do
    run [opt_sbin/"shibd", "-F", "-f", "-p", var/"run/shibboleth/shibd.pid"]
    keep_alive true
    require_root true
  end

  test do
    system sbin/"shibd", "-t"
  end
end
