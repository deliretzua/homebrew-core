class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.254.tar.gz"
  sha256 "6be000a33b665ecac05971819b4c29ba5e21b800627f288f4d3a0b28e86b290f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e751552e0ef74c628343d71a9e44adccf94fe84deb5d1c47cce440c7db88cce2"
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
