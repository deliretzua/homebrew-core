class SofiaSip < Formula
  desc "SIP User-Agent library"
  homepage "https://sofia-sip.sourceforge.io/"
  url "https://github.com/freeswitch/sofia-sip/archive/v1.13.13.tar.gz"
  sha256 "7ca4e0a31f9ee2f3e10d5170c02dcaa595bd5cfff3e8005aa7d846a8e62dd15e"
  license "LGPL-2.1-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1514b21e9dec127cbb1f3b49fda1e6cc0b0d1259e4762e392ef9f25933875151"
    sha256 cellar: :any,                 arm64_monterey: "9f00bc43eabee791ffb5e2639cac4f792e49a5485cd20e97bc40de59eedf32e0"
    sha256 cellar: :any,                 arm64_big_sur:  "49692dca83d35179e7754fc825d060cb29ee53eeb7c2e3ed5f2df2193efa8644"
    sha256 cellar: :any,                 ventura:        "120d5f17a56f48a6de094135ba6b56ab66c62c06b2c85f2c4a68066552b7a1a7"
    sha256 cellar: :any,                 monterey:       "abf98051d6e0bd8fedf7a5cab730dc7ed578ff44d36156a53ad9a43b4d51c114"
    sha256 cellar: :any,                 big_sur:        "06276e4a41103eca3d4bbe2d195c0ec87f71d16e7ebc24b1ee547d708a2a1bc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "02b921d146163c3ee6e4c491b6f75ba89ed72809d0f028465b6641fbe38b586c"
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
