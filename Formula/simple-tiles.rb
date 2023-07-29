class SimpleTiles < Formula
  desc "Image generation library for spatial data"
  homepage "https://github.com/propublica/simple-tiles"
  url "https://github.com/propublica/simple-tiles/archive/v0.6.2.tar.gz"
  sha256 "343ae52a0b20ee091b14bc145b7c78fed13b7272acd827626283b70f178dfa34"
  license "MIT"
  revision 1
  head "https://github.com/propublica/simple-tiles.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cc1b55956a768a7a1b92c40a542be470a10a1027a0a2cf30359c31aa89931d1f"
    sha256 cellar: :any,                 arm64_monterey: "296d316b3154f92ec1f93f9bba63e42730bb23e4dcd20c1db4377f5fd048e5c3"
    sha256 cellar: :any,                 arm64_big_sur:  "c555d445d78dff44c83a70f858d8b375576bdfb77f5842dfe7c32598478a99e1"
    sha256 cellar: :any,                 ventura:        "2f7b1f944e63811df9315ce5361886ff3b9f52c655d72cbb333222b843480e64"
    sha256 cellar: :any,                 monterey:       "ce11763b3d45c295be832c75f1531d5078e8753db3ea8c0f85e34ebba1382be0"
    sha256 cellar: :any,                 big_sur:        "67f028556f03bb162daae37bb2a71b905c5da15f1b44dc53b070fae50c7586b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d195da33e36555889978b93f1b8e6927bf63202b6cb2bea92d986f7ba81ef4e"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "cairo"
  depends_on "gdal"
  depends_on "pango"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <simple-tiles/simple_tiles.h>

      int main(){
        simplet_map_t *map = simplet_map_new();
        simplet_map_free(map);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsimple-tiles",
           "-I#{Formula["cairo"].opt_include}/cairo",
           "-I#{Formula["gdal"].opt_include}",
           "-I#{Formula["glib"].opt_include}/glib-2.0",
           "-I#{Formula["glib"].opt_lib}/glib-2.0/include",
           "-I#{Formula["harfbuzz"].opt_include}/harfbuzz",
           "-I#{Formula["pango"].opt_include}/pango-1.0",
           "-o", "test"
    system testpath/"test"
  end
end
