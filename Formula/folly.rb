class Folly < Formula
  desc "Collection of reusable C++ library artifacts developed at Facebook"
  homepage "https://github.com/facebook/folly"
  url "https://github.com/facebook/folly/archive/v2023.01.30.00.tar.gz"
  sha256 "d489c25863759313d029348cdee5627c23fec12e866587aadfa544184d59ccab"
  license "Apache-2.0"
  head "https://github.com/facebook/folly.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "6a9694114fe3b9c01cc181379a15ab0c42961f87a064f014f46768b2ebb93e53"
    sha256 cellar: :any,                 arm64_monterey: "cee45b1607122cd98a3d40e335c42c041f9bc9f6e93aa0a6869e24746d5b5843"
    sha256 cellar: :any,                 arm64_big_sur:  "8862413db99e2d1fa3981054e822ef1831e59802533c54d512fc6aae5951df76"
    sha256 cellar: :any,                 ventura:        "b2a59d58f25c489ad9695f74cec92569f1aa11bc9b237d9d554edbdf4aefd66c"
    sha256 cellar: :any,                 monterey:       "37faf40dc5d2360eaa7f639ebdab2e2b02b581201370130da49bfba6088c4c3c"
    sha256 cellar: :any,                 big_sur:        "58cd229d8ddc0c3a3c45bf044429bd72cf33467d13ddc03940979b5c3131a923"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7fe426705941dbaccca174f4070962c7d63271421b3803282a4b8c0d3791ece"
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
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "xz"
  depends_on "zstd"

  on_macos do
    depends_on "llvm" if DevelopmentTools.clang_build_version <= 1100
  end

  fails_with :clang do
    build 1100
    # https://github.com/facebook/folly/issues/1545
    cause <<-EOS
      Undefined symbols for architecture x86_64:
        "std::__1::__fs::filesystem::path::lexically_normal() const"
    EOS
  end

  fails_with gcc: "5"

  def install
    ENV.llvm_clang if OS.mac? && (DevelopmentTools.clang_build_version <= 1100)

    args = std_cmake_args + %W[
      -DCMAKE_LIBRARY_ARCHITECTURE=#{Hardware::CPU.arch}
      -DFOLLY_USE_JEMALLOC=OFF
    ]

    system "cmake", "-S", ".", "-B", "build/shared",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", ".", "-B", "build/static",
                    "-DBUILD_SHARED_LIBS=OFF",
                    *args
    system "cmake", "--build", "build/static"
    lib.install "build/static/libfolly.a", "build/static/folly/libfollybenchmark.a"
  end

  test do
    # Force use of Clang rather than LLVM Clang
    ENV.clang if OS.mac?

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
