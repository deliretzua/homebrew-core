class Mapserver < Formula
  desc "Publish spatial data and interactive mapping apps to the web"
  homepage "https://mapserver.org/"
  url "https://download.osgeo.org/mapserver/mapserver-8.0.1.tar.gz"
  sha256 "79d23595ef95d61d3d728ae5e60850a3dbfbf58a46953b4fdc8e6e0ffe5748ba"
  license "MIT"
  revision 1

  livecheck do
    url "https://mapserver.org/download.html"
    regex(/href=.*?mapserver[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "73ee41da196938548f389c4621eed0aaa78fb0f6c8751287e5d0b9d20f93cb77"
    sha256 cellar: :any,                 arm64_monterey: "430b2955dedd6b11b838f471a5476a88f97c9fb7cbbdb9f66826e5c05f23edaa"
    sha256 cellar: :any,                 arm64_big_sur:  "b56896c998756b9dd0522ff8ff35a805eab3fea2a3065eb444f94a4eb811500e"
    sha256 cellar: :any,                 ventura:        "8ea88cc78b3d6305f8dfd0fea5c581e9a98afcb89c37085b849416287021881b"
    sha256 cellar: :any,                 monterey:       "a424b3c4c18796bdc6189ac85ec7820b8e3a237f4c798c37137bfd2ea2904b87"
    sha256 cellar: :any,                 big_sur:        "070c4aa6d6c87a5a1894130c3fa3ccfe69a3e32304b0322e0e87e53ea4cf578a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e74f5c36d8343686eae3c52216a64519ddc49434adf73641936bf6151518d5a6"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "swig" => :build
  depends_on "cairo"
  depends_on "fcgi"
  depends_on "freetype"
  depends_on "gd"
  depends_on "gdal"
  depends_on "geos"
  depends_on "giflib"
  depends_on "libpng"
  depends_on "libpq"
  depends_on "proj"
  depends_on "protobuf-c"
  depends_on "python@3.11"

  uses_from_macos "curl"

  fails_with gcc: "5"

  def python3
    "python3.11"
  end

  def install
    # Install within our sandbox
    inreplace "mapscript/python/CMakeLists.txt", "${Python_LIBRARIES}", "-Wl,-undefined,dynamic_lookup" if OS.mac?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args,
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DWITH_CLIENT_WFS=ON",
                    "-DWITH_CLIENT_WMS=ON",
                    "-DWITH_CURL=ON",
                    "-DWITH_FCGI=ON",
                    "-DWITH_FRIBIDI=OFF",
                    "-DWITH_GDAL=ON",
                    "-DWITH_GEOS=ON",
                    "-DWITH_HARFBUZZ=OFF",
                    "-DWITH_KML=ON",
                    "-DWITH_OGR=ON",
                    "-DWITH_POSTGIS=ON",
                    "-DWITH_PYTHON=ON",
                    "-DWITH_SOS=ON",
                    "-DWITH_WFS=ON",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DPHP_EXTENSION_DIR=#{lib}/php/extensions"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    system python3, "-m", "pip", "install", *std_pip_args, "./build/mapscript/python"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mapserv -v")
    system python3, "-c", "import mapscript"
  end
end
