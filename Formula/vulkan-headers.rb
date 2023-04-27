class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.249.tar.gz"
  sha256 "3d957cc9d07c22b35226c931ac9253321d3b56a769794081a970ccce6b1bbed7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "aa85b923d5a214eda4891f9a770f260b0a5cbd60a0d8364821a22e8b4e0ff77b"
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
