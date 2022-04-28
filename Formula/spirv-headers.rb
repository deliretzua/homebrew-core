class SpirvHeaders < Formula
  desc "Headers for SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Headers"
  url "https://github.com/KhronosGroup/SPIRV-Headers/archive/refs/tags/sdk-1.3.204.1.tar.gz"
  sha256 "262864053968c217d45b24b89044a7736a32361894743dd6cfe788df258c746c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "766e327a320f213123f6f2b5e394cae54e6d80da6f6caac0f4e4c7799b561811"
  end

  depends_on "cmake" => [:build, :test]

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "example"
  end

  test do
    system "cmake", "-S", pkgshare/"example", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
  end
end
