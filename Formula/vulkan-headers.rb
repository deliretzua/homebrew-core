class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.258.tar.gz"
  sha256 "00a1f1859bd1ee8337f75d3c94c8f2d0065b9681f29d7255abaaadfe0c9bb349"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8a1b36db52e18e0c51889f91c8d715a385bb3536cc7016e1036b1c35cf675947"
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
