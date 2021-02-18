class Libmaxminddb < Formula
  desc "C library for the MaxMind DB file format"
  homepage "https://github.com/maxmind/libmaxminddb"
  url "https://github.com/maxmind/libmaxminddb/releases/download/1.5.2/libmaxminddb-1.5.2.tar.gz"
  sha256 "5237076d250a5f7c297e331c35a433eeaaf0dc205e070e4db353c9ba10f340a2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1d9424cee10fcb1c266a934676245365323ae2d4f0216b2ebd083e2e83c2315a"
    sha256 cellar: :any, big_sur:       "25c8c66165ee92126e2eec12376ddffba7d2a8eaa36e4aba840e7977c41285ff"
    sha256 cellar: :any, catalina:      "e075cb109dc0a9d03f4e3e15d2d979f739fe3696bb62052e738ecb193086d923"
    sha256 cellar: :any, mojave:        "36ada94fa2c1300d49d89452c59bc75909d4da63f8bc4232179e071d443d7a75"
  end

  head do
    url "https://github.com/maxmind/libmaxminddb.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "./bootstrap" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "check"
    system "make", "install"
    (share/"examples").install buildpath/"t/maxmind-db/test-data/GeoIP2-City-Test.mmdb"
  end

  test do
    system "#{bin}/mmdblookup", "-f", "#{share}/examples/GeoIP2-City-Test.mmdb",
                                "-i", "175.16.199.0"
  end
end
