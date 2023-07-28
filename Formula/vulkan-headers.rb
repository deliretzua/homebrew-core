class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.260.tar.gz"
  sha256 "f6e44769c42685fd5d380aea280a2406a431fe584d7ae3256ce83958cd0899f4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d93bc966ddeea3d25420141ed40c3b43665868b0ac1c933cc56f609a73b3bfd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d93bc966ddeea3d25420141ed40c3b43665868b0ac1c933cc56f609a73b3bfd0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d93bc966ddeea3d25420141ed40c3b43665868b0ac1c933cc56f609a73b3bfd0"
    sha256 cellar: :any_skip_relocation, ventura:        "d93bc966ddeea3d25420141ed40c3b43665868b0ac1c933cc56f609a73b3bfd0"
    sha256 cellar: :any_skip_relocation, monterey:       "d93bc966ddeea3d25420141ed40c3b43665868b0ac1c933cc56f609a73b3bfd0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d93bc966ddeea3d25420141ed40c3b43665868b0ac1c933cc56f609a73b3bfd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6d230a2dc71f02514d30c3ee2cf032ab90f0c25c3188951fbb520f9fb9b3682"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <vulkan/vulkan_core.h>

      int main() {
        printf("vulkan version %d", VK_VERSION_1_0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-o", "test"
    system "./test"
  end
end
