class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2021.05.17.00.tar.gz"
  sha256 "10449ec28542a8da0f93600b45d2be51ccb5debfcaad2c42d1cbdf6ad204510b"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "84ec9fac8e6ed1664dbca08837546af68675336e60342a97e51a2ec0e4b26b8f"
    sha256 cellar: :any, big_sur:       "f0299acf166e9ba9e5a07253c340d861895b8b031316c54a58d3038a9ad27498"
    sha256 cellar: :any, catalina:      "6f5596d86b3464e234762344c86c692ee70a7431efc9d9b391624a5e5979c09e"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "lz4"
  # https://github.com/facebook/folly/issues/1545
  depends_on macos: :catalina
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  def install
    mkdir "_build" do
      args = std_cmake_args + %w[
        -DFOLLY_USE_JEMALLOC=OFF
      ]

      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=ON"
      system "make"
      system "make", "install"

      system "make", "clean"
      system "cmake", "..", *args, "-DBUILD_SHARED_LIBS=OFF"
      system "make"
      lib.install "libfolly.a", "folly/libfollybenchmark.a"
    end
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <folly/FBVector.h>
      int main() {
        folly::fbvector<int> numbers({0, 1, 2, 3});
        numbers.reserve(10);
        for (int i = 4; i < 10; i++) {
          numbers.push_back(i * 2);
        }
        assert(numbers[6] == 12);
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cc", "-I#{include}", "-L#{lib}",
                    "-lfolly", "-o", "test"
    system "./test"
  end
end
