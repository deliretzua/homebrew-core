class Streamvbyte < Formula
  desc "Fast integer compression in C"
  homepage "https://github.com/lemire/streamvbyte"
  url "https://github.com/lemire/streamvbyte/archive/refs/tags/v0.5.2.tar.gz"
  sha256 "6c64b1bcd69515e77111df274db9cbc471c5d65cb9769c7b95d3b56941b622dd"
  license "Apache-2.0"
  head "https://github.com/lemire/streamvbyte.git", branch: "master"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-I#{include}", "-L#{lib}", "-lstreamvbyte", "-o", "test"
    system testpath/"test"
  end
end
