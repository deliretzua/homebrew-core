class Fizz < Formula
  desc "C++14 implementation of the TLS-1.3 standard"
  homepage "https://github.com/facebookincubator/fizz"
  url "https://github.com/facebookincubator/fizz/releases/download/v2022.09.05.00/fizz-v2022.09.05.00.tar.gz"
  sha256 "38bc2512f8556b98e2c94c220c27b8bc4d551ffdc4d67d84b538fb6ab3fed4d4"
  license "BSD-2-Clause"
  head "https://github.com/facebookincubator/fizz.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "a11285802315a86f5bdeb30860f5070bb5a37a8a54a29a77aa47d9eb1fdc65c8"
    sha256 cellar: :any,                 arm64_big_sur:  "83c7ed9142c3b0d2fc3540ae9fce522bc895b42dd1f3fd7181c70addd64abf57"
    sha256 cellar: :any,                 monterey:       "fb615364834fd99965e3cb3594e8fe6d6fe23aeae7b5a75430f109c65c38fa50"
    sha256 cellar: :any,                 big_sur:        "63aaba6a360d80e93108efc2822d1273b8e6b2926ddf34dce1edc1736befd347"
    sha256 cellar: :any,                 catalina:       "a78d4450661a7d90edf3f03d7ffba8436eb68bddc6f1efcdd1bc50049b85a974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c2aa86c36af640c4ea09d9ecb20f6de228dbd58c97fd876c12b2cf4c37a7b69"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "double-conversion"
  depends_on "fmt"
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "libevent"
  depends_on "libsodium"
  depends_on "lz4"
  depends_on "openssl@1.1"
  depends_on "snappy"
  depends_on "zstd"

  on_linux do
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    args = []
    args << "-DLIBRT_LIBRARY=/usr/lib/x86_64-linux-gnu/librt.so" if OS.linux?

    system "cmake", "-S", "fizz", "-B", "build",
                    "-DBUILD_TESTS=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args, *args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <fizz/client/AsyncFizzClient.h>
      #include <iostream>

      int main() {
        auto context = fizz::client::FizzClientContext();
        std::cout << toString(context.getSupportedVersions()[0]) << std::endl;
      }
    EOS
    system ENV.cxx, "-std=c++14", "test.cpp", "-o", "test",
                    "-I#{include}",
                    "-I#{Formula["openssl@1.1"].opt_include}",
                    "-L#{lib}", "-lfizz",
                    "-L#{Formula["folly"].opt_lib}", "-lfolly",
                    "-L#{Formula["gflags"].opt_lib}", "-lgflags",
                    "-L#{Formula["glog"].opt_lib}", "-lglog",
                    "-L#{Formula["libevent"].opt_lib}", "-levent",
                    "-L#{Formula["libsodium"].opt_lib}", "-lsodium",
                    "-L#{Formula["openssl@1.1"].opt_lib}", "-lcrypto", "-lssl"
    assert_match "TLS", shell_output("./test")
  end
end
