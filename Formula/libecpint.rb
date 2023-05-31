class Libecpint < Formula
  desc "Library for the efficient evaluation of integrals over effective core potentials"
  homepage "https://github.com/robashaw/libecpint"
  url "https://github.com/robashaw/libecpint/archive/v1.0.7.tar.gz"
  sha256 "e9c60fddb2614f113ab59ec620799d961db73979845e6e637c4a6fb72aee51cc"
  license "MIT"

  depends_on "cmake" => :build
  depends_on "libcerf"
  depends_on "pugixml"
  depends_on "python@3.11"

  def install
    args = [
      "-DBUILD_SHARED_LIBS=ON",
      "-DLIBECPINT_USE_CERF=ON",
      "-DLIBECPINT_BUILD_TESTS=OFF",
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "tests/lib/api_test1/test1.cpp",
                     "tests/lib/api_test1/api_test1.output",
                     "include/testutil.hpp"
  end

  test do
    cp [pkgshare/"api_test1.output", pkgshare/"testutil.hpp"], testpath
    system ENV.cxx, "-std=c++11", pkgshare/"test1.cpp",
                    "-DHAS_PUGIXML", "-I#{include}/libecpint",
                    "-L#{lib}", "-lecpint", "-o", "test1"
    system "./test1"
  end
end
