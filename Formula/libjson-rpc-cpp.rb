class LibjsonRpcCpp < Formula
  desc "C++ framework for json-rpc"
  homepage "https://github.com/cinemast/libjson-rpc-cpp"
  url "https://github.com/cinemast/libjson-rpc-cpp/archive/v1.4.0.tar.gz"
  sha256 "8fef7628eadbc0271c685310082ef4c47f1577c3df2e4c8bd582613d1bd10599"
  license "MIT"
  head "https://github.com/cinemast/libjson-rpc-cpp.git"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_big_sur: "0fdc2ac320638aff5068d94d4115182edebd6f705a4d705924abcfb26d4b602a"
    sha256 cellar: :any,                 big_sur:       "96c5a539ae83af10f043b89d47dd4e433089a658c3676a9533716e3e04edb440"
    sha256 cellar: :any,                 catalina:      "451b43048c296d53ea5ca91c6894cbc638710cfc6006426ebc536f143d8c1f04"
    sha256 cellar: :any,                 mojave:        "88c6224dddcb78a2662b1fdecaae8944132fc7b3aec8b0b69b78b73134b52342"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e14796431b71d7f7c6a450e8b585c1ac60d3e70a94de41acfc175c7394749167"
  end

  depends_on "cmake" => :build
  depends_on "argtable"
  depends_on "hiredis"
  depends_on "jsoncpp"
  depends_on "libmicrohttpd"

  uses_from_macos "curl"

  def install
    system "cmake", ".", *std_cmake_args, "-DCOMPILE_EXAMPLES=OFF", "-DCOMPILE_TESTS=OFF"
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/jsonrpcstub", "-h"
  end
end
