class Petsc < Formula
  desc "Portable, Extensible Toolkit for Scientific Computation (real)"
  homepage "https://www.mcs.anl.gov/petsc/"
  url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/petsc-lite-3.16.0.tar.gz"
  sha256 "5aaad7deea127a4790c8aa95c42fd9451ab10b5d6c68b226b92d4853002f438d"
  license "BSD-2-Clause"

  livecheck do
    url "https://ftp.mcs.anl.gov/pub/petsc/release-snapshots/"
    regex(/href=.*?petsc-lite[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "28a26e696cf114357a55bae1c3b9657284f32ea927bfe68633e263820247e919"
    sha256 big_sur:       "3c9bc09c4ec73d4506feb28cfa8ce776adfb0297f6eecd46c9a85aa323fd5c17"
    sha256 catalina:      "47221910e469efed778001b553e445cf4274ee0e2c6af8f678ae80bbed8b26e2"
    sha256 mojave:        "10d8ed0bd248fc43a6ef914c054b6ac34e0653cfcee391d38e41a04018b3bb6f"
  end

  depends_on "hdf5"
  depends_on "hwloc"
  depends_on "metis"
  depends_on "netcdf"
  depends_on "open-mpi"
  depends_on "openblas"
  depends_on "scalapack"
  depends_on "suite-sparse"

  conflicts_with "petsc-complex", because: "petsc must be installed with either real or complex support, not both"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-debugging=0",
                          "--with-scalar-type=real",
                          "--with-x=0",
                          "--CC=mpicc",
                          "--CXX=mpicxx",
                          "--F77=mpif77",
                          "--FC=mpif90",
                          "MAKEFLAGS=$MAKEFLAGS"
    system "make", "all"
    system "make", "install"

    # Avoid references to Homebrew shims
    rm_f lib/"petsc/conf/configure-hash"

    if OS.mac?
      inreplace lib/"petsc/conf/petscvariables", Superenv.shims_path, ""
    elsif File.readlines("#{lib}/petsc/conf/petscvariables").grep(Superenv.shims_path.to_s).any?
      inreplace lib/"petsc/conf/petscvariables", Superenv.shims_path, ""
    end
  end

  test do
    test_case = "#{pkgshare}/examples/src/ksp/ksp/tutorials/ex1.c"
    system "mpicc", test_case, "-I#{include}", "-L#{lib}", "-lpetsc", "-o", "test"
    output = shell_output("./test")
    # This PETSc example prints several lines of output. The last line contains
    # an error norm, expected to be small.
    line = output.lines.last
    assert_match(/^Norm of error .+, Iterations/, line, "Unexpected output format")
    error = line.split[3].to_f
    assert (error >= 0.0 && error < 1.0e-13), "Error norm too large"
  end
end
