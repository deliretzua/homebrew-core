class Frei0r < Formula
  desc "Minimalistic plugin API for video effects"
  homepage "https://frei0r.dyne.org/"
  url "https://github.com/dyne/frei0r/archive/refs/tags/v2.3.0.tar.gz"
  sha256 "00aa65a887445c806b2a467abc3ccc4b0855f7eaf38ed2011a1ff41e74844fa0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "40373a9832b28d15c8ffaa880b775882c25b0ab93ab31ae19ec2f2a27799731b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dc29537f1ea00bd0f303886fa5819ef44890f0435b12276919c952104843247b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c45ba867a2cc39664a405db9cb2ee9f97289f101fff6be8ca9ba88dcfcb19f8e"
    sha256 cellar: :any_skip_relocation, ventura:        "49619d94f0580ee04d812a1e598d266f31a571cdda1bff9a297fa11b0c96aaf4"
    sha256 cellar: :any_skip_relocation, monterey:       "27768088554351600fcc15987a3671cf7cd133533c41fad06776383c4f96cb2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "e97f700c8a5a2df70aeb941217314d313df4f343992c9dfa8a4f1b80300add27"
    sha256 cellar: :any_skip_relocation, catalina:       "0287b2caef7477439e9e07420e68ba794524b9348807c36903d5c22caf84134e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d33e8b0bd9932b996d6d2f612b4d1484ca9c41466b2c5df1e3db6fcbebf5bf6"
  end

  depends_on "cmake" => :build

  def install
    # Disable opportunistic linking against Cairo
    inreplace "CMakeLists.txt", "find_package (Cairo)", ""

    args = %w[
      -DWITHOUT_OPENCV=ON
      -DWITHOUT_GAVL=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <frei0r.h>

      int main()
      {
        int mver = FREI0R_MAJOR_VERSION;
        if (mver != 0) {
          return 0;
        } else {
          return 1;
        }
      }
    EOS
    system ENV.cc, "-L#{lib}", "test.c", "-o", "test"
    system "./test"
  end
end
