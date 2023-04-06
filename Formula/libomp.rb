class Libomp < Formula
  desc "LLVM's OpenMP runtime library"
  homepage "https://openmp.llvm.org/"
  url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.1/openmp-16.0.1.src.tar.xz"
  sha256 "3385718b1865c7a9ef45e8923a8e2487d23c20e1b8b4c18df6c5a2881eddf18a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^llvmorg[._-]v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9da7c08b29a9dd96d31180c0543efb714c2905176b54ac2f4d634a1c499643a4"
    sha256 cellar: :any,                 arm64_monterey: "6a1fcf0e6f0cb4b48a7744f635f7846498d3db5339e869654ff000f926b3e26e"
    sha256 cellar: :any,                 arm64_big_sur:  "dd229591bbd635ab9b2baaeba81852829aeaa5883f047179bbe9e1a023abdb22"
    sha256 cellar: :any,                 ventura:        "99f87fcf60b731a71844693f8968f335930a5195ba82b2fd77c443d2c95d8d80"
    sha256 cellar: :any,                 monterey:       "73ece4f5ff52a838ecb7aa7395826e897d9971e38ca24bff1d46b7bdc79595c7"
    sha256 cellar: :any,                 big_sur:        "a75a5596d74f5235f83696eecf255716e0e157697fc790fabd14dc615b89c7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6641c36c0069233b4c21b625376e5ce5afa3311bf97dc69b4f32b97fda284099"
  end

  # Ref: https://github.com/Homebrew/homebrew-core/issues/112107
  keg_only "it can override GCC headers and result in broken builds"

  depends_on "cmake" => :build
  depends_on "lit" => :build
  uses_from_macos "llvm" => :build

  on_linux do
    depends_on "python@3.11"
  end

  resource "cmake" do
    url "https://github.com/llvm/llvm-project/releases/download/llvmorg-16.0.1/cmake-16.0.1.src.tar.xz"
    sha256 "f7b070b0ea71251c81b1a3dcdc6ccd28f59615e3e386c461456c5c246406acdc"
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
    assert_equal version, resource("cmake").version, "`cmake` resource needs updating!"
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
