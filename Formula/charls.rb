class Charls < Formula
  desc "C++ JPEG-LS library implementation"
  homepage "https://github.com/team-charls/charls"
  url "https://github.com/team-charls/charls/archive/refs/tags/2.4.2.tar.gz"
  sha256 "d1c2c35664976f1e43fec7764d72755e6a50a80f38eca70fcc7553cad4fe19d9"
  license "BSD-3-Clause"
  head "https://github.com/team-charls/charls.git", branch: "main"

  depends_on "cmake" => :build

  def install
    args = %w[
      -DCHARLS_BUILD_TESTS=OFF
      -DCHARLS_BUILD_FUZZ_TEST=OFF
      -DCHARLS_BUILD_SAMPLES=OFF
      -DBUILD_SHARED_LIBS=ON
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <charls/charls.h>
      #include <iostream>

      int main() {
        charls::jpegls_encoder encoder;
        std::cout << "ok" << std::endl;
        return 0;
      }
    EOS

    system ENV.cxx, "test.cpp", "-std=c++14", "-I#{include}", "-L#{lib}", "-lcharls", "-o", "test"
    assert_equal "ok", shell_output(testpath/"test").chomp
  end
end
