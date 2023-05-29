class Libprotoident < Formula
  desc "Performs application layer protocol identification for flows"
  homepage "https://github.com/wanduow/libprotoident"
  url "https://github.com/LibtraceTeam/libprotoident/archive/refs/tags/2.0.15-1.tar.gz"
  sha256 "cfa7c2d8db8e701db9f991e4f58fd9a284db65e866194ad54e413202163b7289"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e27cc2aed2ad9540fcc59f31c44e344563791b7e4d9bc32666fa0985c6207c5c"
    sha256 cellar: :any,                 arm64_big_sur:  "a691563d3544dbf21b11e113c8824abfe4032ec1a9ee7747dc19efeb80e57142"
    sha256 cellar: :any,                 monterey:       "d4cb3998fdb1ee58414f3aeb749e599c7ec90d09c93c3308adf4157846fb0018"
    sha256 cellar: :any,                 big_sur:        "2d9d6b65eea9e1a878a3eb12929ddc7752f295998be449e8ceca0cb24231ae24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99a441a0da1600b386ed225d9c305889b84898371d7b3d926e27c2b071066c1e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libflowmanager"
  depends_on "libtrace"

  def install
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args,
                          "--disable-silent-rules"
    system "make", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <libprotoident.h>

      int main() {
        lpi_init_library();
        return 0;
      }
    EOS
    system ENV.cc, "test.cpp", "-L#{lib}", "-lprotoident", "-o", "test"
    system "./test"
  end
end
