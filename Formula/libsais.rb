class Libsais < Formula
  desc "Fast linear time suffix array, lcp array and bwt construction"
  homepage "https://github.com/IlyaGrebnov/libsais"
  url "https://github.com/IlyaGrebnov/libsais/archive/refs/tags/v2.7.2.tar.gz"
  sha256 "16863b9e593733df38ecb1e58675f66dd6f8e72d5dd2175ec4bc62efa8edc7a7"
  license "Apache-2.0"
  head "https://github.com/IlyaGrebnov/libsais.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e75cb03d9d2dbe5092d94da6061ded5699fcd06963e775dfcc7b0360dcfc397"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcd00897d5e9988eefc46902791fb8413bbe356e4fb73d4b602534e5c235ad0a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75fd53da29331ef2cb290f6200e1c1c8aab5cd83073072729e4d0e5fedfb60db"
    sha256 cellar: :any_skip_relocation, ventura:        "2e69104dbcf0826d1afa9304b81489ea48b847f0e8dc3bc2f0ba7d164bde4809"
    sha256 cellar: :any_skip_relocation, monterey:       "ddd2a143aa85e9a4f45e55e87681ec41bb0ace228c26b987ec04ad021fc91ba3"
    sha256 cellar: :any_skip_relocation, big_sur:        "8392cb1c94a427c0ee4c863353b7b490e77ea384a755da07c128692b3d96105c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f3bb77bd69880572993056ff586102ad1b6c19248e400452c25e587a1271def1"
  end

  def install
    system ENV.cc, "-c", *Dir.glob("*.c")
    system ENV.cc, "-shared", "-o", shared_library("libsais"), *Dir.glob("*.o")
    system "ar", "rcs", "libsais.a", *Dir.glob("*.o")

    include.install Dir.glob("*.h")
    lib.install shared_library("libsais"), "libsais.a"
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
