class Bullet < Formula
  desc "Physics SDK"
  homepage "https://bulletphysics.org/"
  license "Zlib"
  head "https://github.com/bulletphysics/bullet3.git", branch: "master"

  stable do
    url "https://github.com/bulletphysics/bullet3/archive/3.22b.tar.gz"
    version "3.22b"
    sha256 "c6cd89ecbc4bd73fee64723c831c1578daab056d88774755a6f56afc6f417b2b"

    # Fix btSoftBodyHelpers.h invalid dependency on example header that is not installed.
    # Remove in the next release.
    patch do
      url "https://github.com/bulletphysics/bullet3/commit/4f0673810cab0eee67ea314a3243952afd150cb4.patch?full_index=1"
      sha256 "577ec365785924f29533bf5bdaef168c851e414aeebd3fe8b4a2d5286d773553"
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "30a87e90fe654bae66c48b1992d4626c6ae46b4eefa2c0ce5032527df006d75c"
    sha256 cellar: :any,                 arm64_big_sur:  "19b6ccc0cbf6aeb43f9ef9eb89f5f74d0c33e0e7d2a4a81e86f93a402bf092e2"
    sha256 cellar: :any,                 monterey:       "5b24686d6901127967ba097dfa0200c2b17eba48600d480cb310e8d3f1ea554b"
    sha256 cellar: :any,                 big_sur:        "c9801c68a5705930efd11f8c5a4d07f95d69a36ecf303e0914c50fe2cc5f1dac"
    sha256 cellar: :any,                 catalina:       "42924c0b6e8d5641fdee26791f7726d8615b568c5eec64207d14836638251677"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c2edebdf03c1345f393e924a68f24b6a92041b9de14ad99bd126d4c57791e23b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build

  def install
    # C++11 for nullptr usage in examples. Can remove when fixed upstream.
    # Issue ref: https://github.com/bulletphysics/bullet3/pull/4243
    ENV.cxx11 if OS.linux?

    common_args = %w[
      -DBT_USE_EGL=ON
      -DBUILD_UNIT_TESTS=OFF
      -DINSTALL_EXTRA_LIBS=ON
    ]

    double_args = std_cmake_args + %W[
      -DCMAKE_INSTALL_RPATH=#{opt_lib}/bullet/double
      -DUSE_DOUBLE_PRECISION=ON
      -DBUILD_SHARED_LIBS=ON
    ]

    mkdir "builddbl" do
      system "cmake", "..", *double_args, *common_args
      system "make", "install"
    end
    dbllibs = lib.children
    (lib/"bullet/double").install dbllibs

    args = std_cmake_args + %W[
      -DBUILD_PYBULLET_NUMPY=ON
      -DCMAKE_INSTALL_RPATH=#{opt_lib}
    ]

    mkdir "build" do
      system "cmake", "..", *args, *common_args, "-DBUILD_SHARED_LIBS=OFF", "-DBUILD_PYBULLET=OFF"
      system "make", "install"

      system "make", "clean"

      system "cmake", "..", *args, *common_args, "-DBUILD_SHARED_LIBS=ON", "-DBUILD_PYBULLET=ON"
      system "make", "install"
    end

    # Install single-precision library symlinks into `lib/"bullet/single"` for consistency
    lib.each_child do |f|
      next if f == lib/"bullet"

      (lib/"bullet/single").install_symlink f
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "LinearMath/btPolarDecomposition.h"
      int main() {
        btMatrix3x3 I = btMatrix3x3::getIdentity();
        btMatrix3x3 u, h;
        polarDecompose(I, u, h);
        return 0;
      }
    EOS

    cxx_lib = if OS.mac?
      "-lc++"
    else
      "-lstdc++"
    end

    # Test single-precision library
    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system "./test"

    # Test double-precision library
    system ENV.cc, "test.cpp", "-I#{include}/bullet", "-L#{lib}/bullet/double",
                   "-lLinearMath", cxx_lib, "-o", "test"
    system "./test"
  end
end
