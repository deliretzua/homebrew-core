class Traildb < Formula
  desc "Blazingly-fast database for log-structured data"
  homepage "https://traildb.io/"
  url "https://github.com/traildb/traildb/archive/0.6.tar.gz"
  sha256 "f73515fe56c547f861296cf8eecc98b8e8bf00d175ad9fb7f4b981ad7cf8b67c"
  license "MIT"

  livecheck do
    url "https://github.com/traildb/traildb.git"
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256               arm64_ventura:  "e6cfb6d3774726751b01bd92b0fdd2914f7da94e95b387c3ad620520e495d056"
    sha256               arm64_monterey: "3c521476cc334c1807abab60f30de5bc89f4072db9ea2d19dbc6b2af12fd3fe8"
    sha256               arm64_big_sur:  "19a39e075d27b18c38f78445471e9703c2ccc051ffad8cad6e6bcc9986954540"
    sha256               ventura:        "861d861ead74e0e2a35bc2a74537b836073d64c0bde9a133bd082375a0ea0baf"
    sha256               monterey:       "0f449d362ce4d34470fb671ba8ac5f079b79f6306c66937a59be76ba980e6b2f"
    sha256               big_sur:        "820982878b9a22783810620d6c42e976048d6711e42fc88cfbf315c18fbdc117"
    sha256 cellar: :any, catalina:       "d838c36b8e7fd566e034374e1fe05e5a2db41940229f7324fec53a2e7387db48"
    sha256 cellar: :any, mojave:         "61992aff616c9e39b703e8b2c138f3997dd9ba7ec6c85eea711605327e221b1f"
    sha256 cellar: :any, high_sierra:    "b383a6635462acd29d12473520ff1cf70920c429f0ed9a010cf2860bf7df3180"
    sha256 cellar: :any, sierra:         "e84323b169f8a2d3ccadadb65d968c99265f37f581d9fe002c259b76b180776e"
    sha256 cellar: :any, el_capitan:     "901e2214b9ddcd214b857db69569c12f85041e6cd087df00ef1c0d624605effe"
    sha256               x86_64_linux:   "8e7e03c9d6643c27eaf9e91dd02d75b8fdfbb484132c87328b9331bb25e73704"
  end

  depends_on "pkg-config" => :build
  depends_on "judy"
  depends_on "libarchive"

  uses_from_macos "python" => :build

  # Update waf script for Python 3
  # Use resource instead of patch since applying corrupts waf
  resource "waf" do
    url "https://raw.githubusercontent.com/traildb/traildb/053ed8e5d0301c792f3ee703cd9936c49ecf41a1/waf"
    sha256 "2e0cf83a63843da127610420cef1d3126f1187d8e572b6b3a28052fc2250d4bf"
  end

  def install
    ENV["PREFIX"] = prefix
    buildpath.install resource("waf")
    system "python3", "./waf", "configure", "install"
  end

  test do
    # Check that the library has been installed correctly
    (testpath/"test.c").write <<~EOS
      #include <traildb.h>
      #include <assert.h>
      int main() {
        const char *path = "test.tdb";
        const char *fields[] = {};
        tdb_cons* c1 = tdb_cons_init();
        assert(tdb_cons_open(c1, path, fields, 0) == 0);
        assert(tdb_cons_finalize(c1) == 0);
        tdb* t1 = tdb_init();
        assert(tdb_open(t1, path) == 0);
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-ltraildb", "-o", "test"
    system "./test"

    # Check that the provided tdb binary works correctly
    (testpath/"in.csv").write("1234 1234\n")
    system bin/"tdb", "make", "-c", "-i", "in.csv", "--tdb-format", "pkg"
  end
end
