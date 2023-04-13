class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.247.tar.gz"
  sha256 "4c5c99bd64b5f74bdaec012e69dd5567deb52d78f12f6d2c43c29fd0a1eee87e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "47e1ce5874da563ec81c398dfbce2e3401121adec0de6cc6819a5ebf250f3be4"
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
