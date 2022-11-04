class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.4/openmp-15.0.4.src.tar.xz"
  sha256 "1b6f92013e7555759127d84264c3e98eab116a3a5138570058d8507e1513f76e"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "59ea0fadbcdd9c8647057c420d220dfbafaae877f9090585be45def2fb3b0ede"
    sha256 cellar: :any,                 arm64_monterey: "694b2c1c0bda000cb49776222558c021cc71a57ac1a1152421131c2f9dfbf581"
    sha256 cellar: :any,                 arm64_big_sur:  "786cda2afd0aa47f137a7ec53f9bd32cbad00f0cf47144b07d42875eb1b91b86"
    sha256 cellar: :any,                 monterey:       "222ec35ce81fc3323f2af7ecfc16ed45474f92c7e882f5369abdb6b0673eb214"
    sha256 cellar: :any,                 big_sur:        "bcdd4b17362ccae808de9d225dc998000210654239d790eab3043cbdd46d8de7"
    sha256 cellar: :any,                 catalina:       "04c9e8cbc25803bc09a131570c4a6e18cb6f8d5bb9efb26cae0a03bd7f5fe749"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "37ba6b6a4192807e036037698fbc202042aaff749f56c50acf2b29fe235dc2f3"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-15.0.3/cmake-15.0.3.src.tar.xz"
    sha256 "21cf3f52c53dc8b8972122ae35a5c18de09c7df693b48b5cd8553c3e3fed090d"
  end

  def install
    (buildpath/"src").install buildpath.children
    (buildpath/"cmake").install resource("cmake")

    # Disable LIBOMP_INSTALL_ALIASES, otherwise the library is installed as
    # libgomp alias which can conflict with GCC's libgomp.
    args = ["-DLIBOMP_INSTALL_ALIASES=OFF"]
    args << "-DOPENMP_ENABLE_LIBOMPTARGET=OFF" if OS.linux?

    system "cmake", "-S", "src", "-B", "build/shared", *std_cmake_args, *args
    system "cmake", "--build", "build/shared"
    system "cmake", "--install", "build/shared"

    system "cmake", "-S", "src", "-B", "build/static",
                    "-DLIBOMP_ENABLE_SHARED=OFF",
                    *std_cmake_args, *args
    system "cmake", "--build", "build/static"
    system "cmake", "--install", "build/static"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <omp.h>
      #include <array>
      int main (int argc, char** argv) {
        std::array<size_t,2> arr = {0,0};
        #pragma omp parallel num_threads(2)
        {
            size_t tid = omp_get_thread_num();
            arr.at(tid) = tid + 1;
        }
        if(arr.at(0) == 1 && arr.at(1) == 2)
            return 0;
        else
            return 1;
      }
    EOS
    system ENV.cxx, "-Werror", "-Xpreprocessor", "-fopenmp", "test.cpp", "-std=c++11",
                    "-I#{include}", "-L#{lib}", "-lomp", "-o", "test"
    system "./test"
  end
end
