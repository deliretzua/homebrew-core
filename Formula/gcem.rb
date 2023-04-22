class Gcem < Formula
  desc "C++ compile-time math library"
  homepage "https://gcem.readthedocs.io/en/latest/"
  url "https://github.com/kthohr/gcem/archive/refs/tags/v1.17.0.tar.gz"
  sha256 "74cc499e2db247c32f1ce82fc22022d22e0f0a110ecd19281269289a9e78a6f8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "edc22a130753830373e43d97d82aafe6bcf72501d5fa1bdc6f06be10aaacc5ce"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <gcem.hpp>

      int main() {
        constexpr int x = 10;
        std::cout << gcem::factorial(x) << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++11", "-I#{include}", "-o", "test"
    assert_equal "3628800\n", shell_output("./test")
  end
end
