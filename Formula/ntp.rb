class Ntp < Formula
  desc "Network Time Protocol (NTP) Distribution"
  homepage "https://www.ntp.org"
  url "https://www.eecis.udel.edu/~ntp/ntp_spool/ntp4/ntp-4.2/ntp-4.2.8p17.tar.gz"
  version "4.2.8p17"
  sha256 "103dd272e6a66c5b8df07dce5e9a02555fcd6f1397bdfb782237328e89d3a866"
  license all_of: ["BSD-2-Clause", "NTP"]

  livecheck do
    url "https://www.ntp.org/downloads.html"
    regex(/href=.*?ntp[._-]v?(\d+(?:\.\d+)+(?:p\d+)?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7223754b29694eb7fe6014eb532b3de73998bd65fb1a15849f3df71f4bd0302f"
    sha256 cellar: :any,                 arm64_monterey: "e4fbc3d8d55e81f7d2f98dd3fce10e447cd3b417504141b02b0ef5756a76e5f8"
    sha256 cellar: :any,                 arm64_big_sur:  "a356674bddd12589f1c2f26648dc0ab3d5fa295b7c3f6c82240eb0f12c36e79e"
    sha256 cellar: :any,                 ventura:        "27d33afd21ceac4f1ae9a1dfbdedf3c87e02e6955046fdfda51adde897eb6a27"
    sha256 cellar: :any,                 monterey:       "b32043c4e0699e526f2ece7f4c8a93663c0bb87cfa160494dc93a53db3b30f1d"
    sha256 cellar: :any,                 big_sur:        "a28fc40847abff65ea9975ed8c439741bf0b1c03e31a1974dbde0f4c4b84ee85"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5e575b783e49d4992ab994fcd02121f840e491759375a44686b0d582e3296d8"
  end

  depends_on "openssl@3"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-openssl-libdir=#{Formula["openssl@3"].lib}
      --with-openssl-incdir=#{Formula["openssl@3"].include}
      --with-net-snmp-config=no
    ]

    system "./configure", *args
    ldflags = "-lresolv"
    ldflags = "#{ldflags} -undefined dynamic_lookup" if OS.mac?
    system "make", "install", "LDADD_LIBNTP=#{ldflags}"
  end

  test do
    # On Linux all binaries are installed in bin, while on macOS they are split between bin and sbin.
    ntpdate_bin = OS.mac? ? sbin/"ntpdate" : bin/"ntpdate"
    assert_match "step time server ", shell_output("#{ntpdate_bin} -bq pool.ntp.org")
  end
end
