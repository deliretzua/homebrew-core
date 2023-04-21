class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.7.3.tar.gz"
  sha256 "45d37dc12975c4d40db786f322cd6dcfd9f56a8f23741205fcd0fca6ec0bf246"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "53296eb3235533c4ead32229d94d13955dec931244c01bc7976375402f85bf51"
    sha256 cellar: :any,                 arm64_monterey: "a3be3792e44111fffc1096d712b29bb86d92d1fcbfdd05811dde1cc67db37568"
    sha256 cellar: :any,                 arm64_big_sur:  "5e9c8635cbf61a2ff479158134374c211353b69f046d2711776c81ebcda544fc"
    sha256 cellar: :any,                 ventura:        "07d18eada33a1a025287e414264c0c74b5c1fffa235d24d881034dd9956e595e"
    sha256 cellar: :any,                 monterey:       "5139fd24859c292aef27e7075298068ed0489236ea4d5a5868cb5a514b006f53"
    sha256 cellar: :any,                 big_sur:        "1889c356b4f7060a353359dbe59737777199ce70fff96d40a156a574a1b53140"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57ef2fd00a0946441ec53636ae21ff16296106aede9d363ec3a9823d892b3b91"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DLIBSAIS_BUILD_SHARED_LIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    lib.install shared_library("build/liblibsais")
    lib.install_symlink shared_library("liblibsais") => shared_library("libsais")
    include.install "include/libsais.h"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libsais.h>
      #include <stdlib.h>
      int main() {
        uint8_t input[] = "homebrew";
        int32_t sa[8];
        libsais(input, sa, 8, 0, NULL);

        if (sa[0] == 4 &&
            sa[1] == 3 &&
            sa[2] == 6 &&
            sa[3] == 0 &&
            sa[4] == 2 &&
            sa[5] == 1 &&
            sa[6] == 5 &&
            sa[7] == 7) {
            return 0;
        }
        return 1;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lsais", "-o", "test"
    system "./test"
  end
end
