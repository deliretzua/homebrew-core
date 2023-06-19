class Pinocchio < Formula
  desc "Efficient and fast C++ library implementing Rigid Body Dynamics algorithms"
  homepage "https://stack-of-tasks.github.io/pinocchio"
  url "https://github.com/stack-of-tasks/pinocchio/releases/download/v2.6.19/pinocchio-2.6.19.tar.gz"
  sha256 "acfe29de311aa284d829070bf3cb1941166ca3d6fd1331ad63cb094a793273d9"
  license "BSD-2-Clause"
  head "https://github.com/stack-of-tasks/pinocchio.git", branch: "master"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 ventura:      "e96575b1d93d3562811cd0e946a7d3f95fec0bcc5c08fea18ddef71119cd06af"
    sha256 cellar: :any,                 monterey:     "e83654805a397b93cc1ddb87c71363e63b7fffa41aae65db333e4a91ad072471"
    sha256 cellar: :any,                 big_sur:      "82c8bb63a3483df30ff2fbb3c0218d1455e135e9ae8023b21630e4463ad8db79"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "5067e0138a6cd3ad8c5a285f7922579b5e1c0ee456b36f2f1a0485279213942b"
  end

  depends_on "cmake" => :build
  depends_on "doxygen" => :build
  depends_on "boost"
  depends_on "eigen"
  depends_on "eigenpy"
  depends_on "hpp-fcl"
  depends_on "python@3.11"
  depends_on "urdfdom"

  def python3
    "python3.11"
  end

  def install
    if build.head?
      system "git", "submodule", "update", "--init"
      system "git", "pull", "--unshallow", "--tags"
    end

    system "cmake", "-S", ".", "-B", "build",
                    "-DPYTHON_EXECUTABLE=#{which(python3)}",
                    "-DBUILD_UNIT_TESTS=OFF",
                    "-DBUILD_WITH_COLLISION_SUPPORT=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system python3, "-c", <<~EOS
      import pinocchio
      model = pinocchio.Model()
      data = model.createData()
      assert model.nv == 0 and model.nq == 0
    EOS
  end
end
