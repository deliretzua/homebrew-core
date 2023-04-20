class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.248.tar.gz"
  sha256 "e2a3ef209deee3e47e67f3e57846f343c53b96fbe854f5c7427f0bfee478907f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "350e360974081b04a320a3c391ecf417766ea9f54739a1b5499d34e370f0ae91"
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
