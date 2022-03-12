class VulkanHeaders < Formula
  desc "Vulkan Header files and API registry"
  homepage "https://github.com/KhronosGroup/Vulkan-Headers"
  url "https://github.com/KhronosGroup/Vulkan-Headers/archive/v1.3.207.tar.gz"
  sha256 "e1fd80fa34e24767ce06690c8f6ba39545dd0c318b11b931bd4faf3fbcc34dd1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f4348e4e384caad2bc614f343ae884908d503d7d32743dc173513aa957e58bee"
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
