class Libint < Formula
  desc "Library for computing electron repulsion integrals efficiently"
  homepage "https://github.com/evaleev/libint"
  url "https://github.com/evaleev/libint/archive/v2.7.2.tar.gz"
  sha256 "fd0466ce9eb6786b8c5bbe3d510e387ed44b198a163264dfd7e60b337e295fd9"
  license all_of: ["GPL-3.0-or-later", "LGPL-3.0-or-later"]

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "boost"
  depends_on "eigen"
  depends_on "mpfr"
  depends_on "python@3.11"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
    pkgshare.install "tests/hartree-fock/hartree-fock.cc"
    pkgshare.install "tests/hartree-fock/h2o.xyz"
  end

  test do
    system ENV.cxx, "-std=c++11", pkgshare/"hartree-fock.cc",
      *shell_output("pkg-config --cflags --libs libint2").chomp.split,
      "-I#{Formula["eigen"].opt_include}/eigen3",
      "-o", "hartree-fock"
    system "./hartree-fock", pkgshare/"h2o.xyz"
  end
end
