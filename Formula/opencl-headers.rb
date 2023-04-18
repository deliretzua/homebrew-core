class OpenclHeaders < Formula
  desc "C language header files for the OpenCL API"
  homepage "https://www.khronos.org/registry/OpenCL/"
  url "https://github.com/KhronosGroup/OpenCL-Headers/archive/refs/tags/v2023.04.17.tar.gz"
  sha256 "0ce992f4167f958f68a37918dec6325be18f848dee29a4521c633aae3304915d"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/OpenCL-Headers.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6083670816dff879dc51fdcd1e994da286242c3423750b4024cddf4680990909"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6083670816dff879dc51fdcd1e994da286242c3423750b4024cddf4680990909"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6083670816dff879dc51fdcd1e994da286242c3423750b4024cddf4680990909"
    sha256 cellar: :any_skip_relocation, ventura:        "6083670816dff879dc51fdcd1e994da286242c3423750b4024cddf4680990909"
    sha256 cellar: :any_skip_relocation, monterey:       "6083670816dff879dc51fdcd1e994da286242c3423750b4024cddf4680990909"
    sha256 cellar: :any_skip_relocation, big_sur:        "6083670816dff879dc51fdcd1e994da286242c3423750b4024cddf4680990909"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e448171a7ceeff346f1bedf5787023c683deb11e94a654c85f369f93b020a35b"
  end

  keg_only :shadowed_by_macos, "macOS provides OpenCL.framework"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <CL/opencl.h>

      int main(void) {
        printf("opencl.h standalone test PASSED.");
        return 0;
      }
    EOS

    system ENV.cc, "test.c", "-o", "test", "-I#{include}"
    assert_equal "opencl.h standalone test PASSED.", shell_output("./test")
  end
end
