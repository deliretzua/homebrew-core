class Mpi4py < Formula
  desc "Python bindings for MPI"
  homepage "https://mpi4py.github.io/"
  url "https://github.com/mpi4py/mpi4py/releases/download/3.1.4/mpi4py-3.1.4.tar.gz"
  sha256 "17858f2ebc623220d0120d1fa8d428d033dde749c4bc35b33d81a66ad7f93480"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "171d72deec84e3852549247d17c71e70670f66ad0e4e5c406e27f4bb4016a5d9"
    sha256 cellar: :any, arm64_monterey: "946f6f8a44728bc6d722b99f2d00b1c48ca193e1dfd41141e90fb275c8b75728"
    sha256 cellar: :any, arm64_big_sur:  "a3416cd9880da75b4d5db012357f15aa96ae7d2bfebb5d4c9ec9ae8c793d4ae7"
    sha256 cellar: :any, monterey:       "3a988e161949d411bb04d739dbe6df7656b186ba01bd57e316ab6f1973d2547a"
    sha256 cellar: :any, big_sur:        "34e04f91e516fd44ba1db2d55de5ca8dd75da0c2a789236cb1a569ea8692dac0"
    sha256 cellar: :any, catalina:       "447946e2022c7d0923e50ff8c7408f82a6b063a393b5d55a8f0f499d4846a8a0"
    sha256               x86_64_linux:   "5105e6dde4d9578e270ee47a80b44ccd7127e3dbb8a5d8776a674673d4695d60"
  end

  depends_on "libcython" => :build
  depends_on "open-mpi"
  depends_on "python@3.10"

  def python3
    "python3.10"
  end

  def install
    system python3, *Language::Python.setup_install_args(libexec, python3)

    system python3, "setup.py",
                    "build", "--mpicc=mpicc -shared", "--parallel=#{ENV.make_jobs}",
                    "install", "--prefix=#{prefix}",
                    "--single-version-externally-managed", "--record=installed.txt",
                    "--install-lib=#{prefix/Language::Python.site_packages(python3)}"
  end

  test do
    python = Formula["python@3.10"].opt_bin/python3

    system python, "-c", "import mpi4py"
    system python, "-c", "import mpi4py.MPI"
    system python, "-c", "import mpi4py.futures"

    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python, "-m", "mpi4py.run", "-m", "mpi4py.bench", "helloworld"
    system "mpiexec", "-n", ENV.make_jobs, "--use-hwthread-cpus",
           python, "-m", "mpi4py.run", "-m", "mpi4py.bench", "ringtest", "-l", "10", "-n", "1024"
  end
end
