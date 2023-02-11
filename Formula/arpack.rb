class Arpack < Formula
  desc "Routines to solve large scale eigenvalue problems"
  homepage "https://github.com/opencollab/arpack-ng"
  url "https://github.com/opencollab/arpack-ng/archive/3.9.0.tar.gz"
  sha256 "24f2a2b259992d3c797d80f626878aa8e2ed5009d549dad57854bbcfb95e1ed0"
  license "BSD-3-Clause"
  head "https://github.com/opencollab/arpack-ng.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0d001d2dad64c07caac40ea9b86297e7043ed2ec8077826c62dd29f738cf48d1"
    sha256 cellar: :any,                 arm64_monterey: "6cd9a126eda79774f22cc9ccc51c826e1af7c8cdcb746daba2b5d03d4b20c7ed"
    sha256 cellar: :any,                 arm64_big_sur:  "410a94d3be3f092156ce3d4355a75599b5f1da784d0a658374e7a1836f21dce1"
    sha256 cellar: :any,                 ventura:        "4c51d67833f6d0e2f6ff079d5930ed761db28999ed4856ff597197e7a9602754"
    sha256 cellar: :any,                 monterey:       "4010a411f2217ce34c8759e13e6ed27f5e7bca8bc5668cbd14d0bf8449422826"
    sha256 cellar: :any,                 big_sur:        "d6f5d7ffb0f828ca3436481d406d382d8feae87b71b9d0654622df025efec7a0"
    sha256 cellar: :any,                 catalina:       "9d8358a298e561cab99c9724d012b17d983a054895b0661e9e17bcd7b8b4bb4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a78173eceb8f3f1c5998063fbbaef58169f6a9656e5816a4f4cf32a7b5385844"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  depends_on "eigen"
  depends_on "gcc" # for gfortran
  depends_on "open-mpi"
  depends_on "openblas"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{libexec}
      --with-blas=-L#{Formula["openblas"].opt_lib}\ -lopenblas
      F77=mpif77
      --enable-mpi
      --enable-icb
      --enable-icb-exmm
    ]

    system "./bootstrap"
    system "./configure", *args
    system "make"
    system "make", "install"

    lib.install_symlink Dir["#{libexec}/lib/*"].select { |f| File.file?(f) }
    (lib/"pkgconfig").install_symlink Dir["#{libexec}/lib/pkgconfig/*"]
    pkgshare.install "TESTS/testA.mtx", "TESTS/dnsimp.f",
                     "TESTS/mmio.f", "TESTS/debug.h"
  end

  test do
    ENV.fortran
    system ENV.fc, "-o", "test", pkgshare/"dnsimp.f", pkgshare/"mmio.f",
                       "-L#{lib}", "-larpack",
                       "-L#{Formula["openblas"].opt_lib}", "-lopenblas"
    cp_r pkgshare/"testA.mtx", testpath
    assert_match "reached", shell_output("./test")
  end
end
