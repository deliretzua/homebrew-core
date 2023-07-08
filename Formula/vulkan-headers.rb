class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.257.tar.gz"
  sha256 "e3ee02eff07ebcdb0ddfd06366d986c889f3392b6c4d79615bb06aefc1fda900"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5f658b88b530e4c773ff7c9b4eeab6dcfac595025bcc86aec510a981b41cd49"
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
