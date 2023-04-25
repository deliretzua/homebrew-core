class VulkanExtensionlayer < Formula
  desc "Layer providing Vulkan features when native support is unavailable"
  homepage "https://github.com/KhronosGroup/Vulkan-ExtensionLayer"
  url "https://github.com/KhronosGroup/Vulkan-ExtensionLayer/archive/refs/tags/v1.3.246.tar.gz"
  sha256 "6ce8e35dd56d46f308f4581a4d0cdfd660b9aa733a4271442365fda422d4227b"
  license "Apache-2.0"
  head "https://github.com/KhronosGroup/Vulkan-ExtensionLayer.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "f6ab85457b92d3609b4b9d93a6a5ad05b86b3f5e39c9dfa6a5542fc8ad7620c4"
    sha256 cellar: :any,                 arm64_monterey: "31f0df71950d51bf5c7cee6d16a4483a3a0f84f3730b7e134d7d5aba5a0dd838"
    sha256 cellar: :any,                 arm64_big_sur:  "3ed199451e804a638a2c48fc60ac9fb21639eb4111da26ee96786505579f062c"
    sha256 cellar: :any,                 ventura:        "632b2d721b362d30c236fea25f8e39f364fb61abba9b7efaca294b55e75b9d87"
    sha256 cellar: :any,                 monterey:       "9535d606b37779b42429c4bcb4093c827f51dd8a4c48bea04cb314803171c0ce"
    sha256 cellar: :any,                 big_sur:        "e26230e42f396af17a145d7c0ea644e7ffc6021ed3fff9425ef95943bcfd012c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7a0c41733c932dd98622e1312a328f0d1d61c531b9c4ed25f2e468cca92f1d10"
  end

  depends_on "cmake" => :build
  depends_on "googletest" => :build
  depends_on "python@3.11" => :build
  depends_on "vulkan-loader" => :test
  depends_on "vulkan-tools" => :test
  depends_on "glslang"
  depends_on "spirv-headers"
  depends_on "spirv-tools"
  depends_on "vulkan-headers"

  on_linux do
    depends_on "libxcb" => :build
    depends_on "libxrandr" => :build
    depends_on "mesa" => :build
    depends_on "pkg-config" => :build
    depends_on "wayland" => :build
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DGLSLANG_INSTALL_DIR=#{Formula["glslang"].prefix}",
                    "-DSPIRV_HEADERS_INSTALL_DIR=#{Formula["spirv-headers"].prefix}",
                    "-DSPIRV_TOOLS_INSTALL_DIR=#{Formula["spirv-tools"].prefix}",
                    "-DVULKAN_HEADERS_INSTALL_DIR=#{Formula["vulkan-headers"].prefix}",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def caveats
    <<~EOS
      In order to use these layers in a Vulkan application, you may need to place them in the environment with
        export VK_LAYER_PATH=#{opt_share}/vulkan/explicit_layer.d
    EOS
  end

  test do
    ENV.prepend_path "VK_LAYER_PATH", share/"vulkan/explicit_layer.d"
    ENV["VK_ICD_FILENAMES"] = Formula["vulkan-tools"].lib/"mock_icd/VkICD_mock_icd.json"

    ver = Formula["vulkan-headers"].version
    # Update count and add
    #   VK_LAYER_KHRONOS_shader_object      Shader object layer              #{ver}  version 1
    # on the next release
    expected = <<~EOS
      Instance Layers: count = 2
      --------------------------
      VK_LAYER_KHRONOS_synchronization2   Khronos Synchronization2 layer   #{ver}  version 1
      VK_LAYER_KHRONOS_timeline_semaphore Khronos timeline Semaphore layer #{ver}  version 1
    EOS
    actual = shell_output("vulkaninfo --summary")
    assert_match expected, actual
  end
end
