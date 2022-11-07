class Zabbix < Formula
  desc "Availability and monitoring solution"
  homepage "https://www.zabbix.com/"
  url "https://cdn.zabbix.com/zabbix/sources/stable/6.2/zabbix-6.2.4.tar.gz"
  sha256 "e2526603d9b487a26046de3022e1722b66f4b25542886b3e40a8e2b3bbdbd3b5"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }
  head "https://github.com/zabbix/zabbix.git", branch: "master"

  livecheck do
    url "https://www.zabbix.com/download_sources"
    regex(/href=.*?zabbix[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "a8fddee7ea52f37eb2c0451d379a197ef741e2ded1210b723d95eaf737c1884d"
    sha256 arm64_monterey: "0bc4c6103f1d901011cb6383dc1fa0a5f79dfc0be2635801c4d37bd0c96f9e8c"
    sha256 arm64_big_sur:  "4952ba660354e18f188dbf041fc0e1d0d062ca79c5a94c4a3275288afcb1e3d6"
    sha256 monterey:       "5f42dc265b27425a3911902a7a9610dc20601742f3f1cedd3179b6fc4012237e"
    sha256 big_sur:        "386d3fc3f60076781bcae7db3ba10f783d06a10397aad59d67f6cb105a51753e"
    sha256 catalina:       "0b9689af06b6b4875c5179a8eaf9e54faac98519ad9a7daca95270703c7a6124"
    sha256 x86_64_linux:   "37013a432706013f8ea13df3b94d80f9ef60d89733faff288967ae7d50952733"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "pcre2"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}/zabbix
      --enable-agent
      --with-libpcre2
      --with-openssl=#{Formula["openssl@3"].opt_prefix}
    ]

    if OS.mac?
      sdk = MacOS::CLT.installed? ? "" : MacOS.sdk_path
      args << "--with-iconv=#{sdk}/usr"
    end

    system "./configure", *args
    system "make", "install"
  end

  test do
    system sbin/"zabbix_agentd", "--print"
  end
end
