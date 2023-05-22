class Qpdf < Formula
  desc "Tools for and transforming and inspecting PDF files"
  homepage "https://github.com/qpdf/qpdf"
  url "https://github.com/qpdf/qpdf/releases/download/v11.4.0/qpdf-11.4.0.tar.gz"
  sha256 "b0180971cc1b79b2dfe02ffe28e2c88c47f735888a3a2543dd42b9054ef146e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "a4529c932fbece58c7e9f724a8509a1c1b1d60981f0a5d00c5e4470e786eccd9"
    sha256 cellar: :any,                 arm64_monterey: "e1fe188290f9e218bdd20f52ea0d1a0d394adb2c67d886c89d359a610a683b76"
    sha256 cellar: :any,                 arm64_big_sur:  "fd9162c3ae0bca6c8b6b13bd820a8f05597bfe42c34226d86279608b442f0ba5"
    sha256 cellar: :any,                 ventura:        "e5c6e6ca73f18b9a0c18ab5624d12936788e8ec0498aaecc4d3982d5faefd669"
    sha256 cellar: :any,                 monterey:       "591917b6c49a5884be4fd3dbdceb576c24d23feab4d06153d079fad0ccc8f66f"
    sha256 cellar: :any,                 big_sur:        "d93fdf642414b2d8a4a3e48e6a088add5a42c1453710a8ca05759b892fedf4fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c157b9f90eda69e4c346c57e72edd536e3e6e5d75861fd696e7a18085478b99f"
  end

  depends_on "cmake" => :build
  depends_on "jpeg-turbo"
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DUSE_IMPLICIT_CRYPTO=0",
                    "-DREQUIRE_CRYPTO_OPENSSL=1",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/qpdf", "--version"
  end
end
