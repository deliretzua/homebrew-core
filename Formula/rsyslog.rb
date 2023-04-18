class Rsyslog < Formula
  desc "Enhanced, multi-threaded syslogd"
  homepage "https://www.rsyslog.com/"
  url "https://www.rsyslog.com/files/download/rsyslog/rsyslog-8.2304.0.tar.gz"
  sha256 "d090e90283eb4b80de8b43e5ffc6e4b59c4e3970f2aa91e63beef0a11720d74d"
  license all_of: ["Apache-2.0", "GPL-3.0-or-later", "LGPL-3.0-or-later"]

  livecheck do
    url "https://www.rsyslog.com/downloads/download-v8-stable/"
    regex(/href=.*?rsyslog[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "b1a7ed6814f95a6fbe4858b973af2f6719a7bfc1983d263c47a63fb0c1bbd417"
    sha256 arm64_monterey: "e52eff29c253fbb61862cb1b85e45f180d0342fb3c91cc94a3e49d76b1167107"
    sha256 arm64_big_sur:  "4d1bb386a8757ba93bc75f1d75871151553348d42d891333b5644209f93f3673"
    sha256 ventura:        "89f747cf19212c53d8db3361903930e70f842d1dbf5738477f45c052912b815e"
    sha256 monterey:       "a1a4cb997fb8003c0450d61699e8aeb671ea1a66ee525b52fa2d14e90953f66a"
    sha256 big_sur:        "e55ffb3260240b859cf35089fec89cea135e917f072aba3ea724395da3ec4c24"
    sha256 x86_64_linux:   "c80403c933caa3f9790c7dc47d449f5cb4e11c8f6f9668ae1664ebef4f40cb50"
  end

  depends_on "pkg-config" => :build
  depends_on "gnutls"
  depends_on "libestr"

  uses_from_macos "curl"
  uses_from_macos "zlib"

  resource "libfastjson" do
    url "https://download.rsyslog.com/libfastjson/libfastjson-1.2304.0.tar.gz"
    sha256 "ef30d1e57a18ec770f90056aaac77300270c6203bbe476f4181cc83a2d5dc80c"
  end

  def install
    resource("libfastjson").stage do
      system "./configure", "--disable-dependency-tracking",
                            "--disable-silent-rules",
                            "--prefix=#{libexec}"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--enable-imfile",
                          "--enable-usertools",
                          "--enable-diagtools",
                          "--disable-uuid",
                          "--disable-libgcrypt",
                          "--enable-gnutls"
    system "make"
    system "make", "install"

    (etc/"rsyslog.conf").write <<~EOS
      # minimal config file for receiving logs over UDP port 10514
      $ModLoad imudp
      $UDPServerRun 10514
      *.* /usr/local/var/log/rsyslog-remote.log
    EOS
  end

  def post_install
    mkdir_p var/"run"
  end

  service do
    run [opt_sbin/"rsyslogd", "-n", "-f", etc/"rsyslog.conf", "-i", var/"run/rsyslogd.pid"]
    keep_alive true
    error_log_path var/"log/rsyslogd.log"
    log_path var/"log/rsyslogd.log"
  end

  test do
    result = shell_output("#{opt_sbin}/rsyslogd -f #{etc}/rsyslog.conf -N 1 2>&1")
    assert_match "End of config validation run", result
  end
end
