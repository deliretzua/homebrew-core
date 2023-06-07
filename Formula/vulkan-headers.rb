class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.252.tar.gz"
  sha256 "2262a7ba3e12583a5f5f7ebac0c01003cf106baf0ea75809e07958fa9334ea49"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8df4828dc0a218b5f5b56b9eaa7c80266bcfbd4d75727eaf47ce6f0f6c6a040e"
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
