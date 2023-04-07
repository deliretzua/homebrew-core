class Neomutt < Formula
  desc "E-mail reader with support for Notmuch, NNTP and much more"
  homepage "https://neomutt.org/"
  url "https://github.com/neomutt/neomutt/archive/20230407.tar.gz"
  sha256 "9c1167984337d136368fbca56be8c04a550060a2fdd33c96538910ea13ba6d4f"
  license "GPL-2.0-or-later"
  head "https://github.com/neomutt/neomutt.git", branch: "main"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "dfe562773cad7fc3e15ed43c02a18959e51114ed5cdc27fe3873ea4542b7de53"
    sha256 arm64_monterey: "cb33abce1c1d806a7ec4d7df13b95a9599cc35e7279276a5b474325a04894a06"
    sha256 arm64_big_sur:  "cb5e81ba3b6e50854bfbf46e9e4cf9f691aaa8b50051a2f6408c942ceaf3dbb3"
    sha256 ventura:        "59994a21cccbdddf3d99bc7db646ae5b8c61761f48e45e71917c996169bb07ad"
    sha256 monterey:       "5aa8a643b310ae26c536e79732544e7396459ddf162e5cfe4e097602222b2536"
    sha256 big_sur:        "a3bc1e42d3a011c1c20d34353973189d7cfd72d469247f7974368b6d31721f02"
    sha256 x86_64_linux:   "9cd2589f3e22f89dd1c3849741fe1ff29565b1e7a0a4999610d7984d40858690"
  end

  depends_on "docbook-xsl" => :build
  depends_on "pkg-config" => :build
  # The build breaks when it tries to use system `tclsh`.
  depends_on "tcl-tk" => :build
  depends_on "gettext"
  depends_on "gpgme"
  depends_on "libidn2"
  depends_on "lmdb"
  depends_on "lua"
  depends_on "ncurses"
  depends_on "notmuch"
  depends_on "openssl@1.1"
  depends_on "pcre2"
  depends_on "tokyo-cabinet"

  uses_from_macos "libxslt" => :build # for xsltproc
  uses_from_macos "cyrus-sasl"
  uses_from_macos "krb5"
  uses_from_macos "zlib"

  def install
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --autocrypt
      --gss
      --disable-idn
      --idn2
      --lmdb
      --nls
      --notmuch
      --pcre2
      --sasl
      --sqlite
      --tokyocabinet
      --zlib
      --with-lua=#{Formula["lua"].opt_prefix}
      --with-ncurses=#{Formula["ncurses"].opt_prefix}
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-sqlite=#{Formula["sqlite"].opt_prefix}
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    output = shell_output("#{bin}/neomutt -F /dev/null -Q debug_level")
    assert_equal "set debug_level = 0", output.chomp
  end
end
