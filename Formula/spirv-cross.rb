class SpirvCross < Formula
  desc "Performing reflection and disassembling SPIR-V"
  homepage "https://github.com/KhronosGroup/SPIRV-Cross"
  url "https://github.com/KhronosGroup/SPIRV-Cross/archive/refs/tags/sdk-1.3.243.0.tar.gz"
  sha256 "549fff809de2b3484bcc5d710ccd76ca29cbd764dd304c3687252e2f3d034e06"
  license all_of: [
    "Apache-2.0",
    "MIT",
    "CC-BY-4.0",
    :cannot_represent, # LicenseRef-KhronosFreeUse
  ]
  version_scheme 1

  livecheck do
    url :homepage
    strategy :git
    regex(/^sdk-(\d+\.\d+\.\d+\.\d+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce681803131b114f973e47e23003394b5e4238473a7c595a21a23c0b90b42fa0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81b39909da8d863717546e6e07da98ffeb3861ccf359082ff5fe94dcd4623123"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80a4ee152f875a3b653457ee40e0a05fa9892cc6203fd3d525e16157e646c3c0"
    sha256 cellar: :any_skip_relocation, ventura:        "1206c42b59212e72be0325eafc39eedafe12e70a6b6f452414f304e7a62b51dc"
    sha256 cellar: :any_skip_relocation, monterey:       "bf474aadfd797bf685430e8112a6572a0cd3445e2a694ebed9d234134a3d2f39"
    sha256 cellar: :any_skip_relocation, big_sur:        "224f4a1ac8dbc055a8ea1a431a82e275a3de850f805d7aa5388d05696616e403"
    sha256 cellar: :any_skip_relocation, catalina:       "612183441f7920e7f6a3f4d87181e30ecc071a3d2d20185c8b3d614dc2deb30b"
    sha256 cellar: :any_skip_relocation, mojave:         "df9e5893b35edc958ae73b9e763ff63e35d5e8438f9e67cc332ec14ce00f6def"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95b1a4f371d7235a3c7552c6a9b160adb90ab6dbbc50005d3e89981a0ffe93b6"
  end

  depends_on "cmake" => :build
  depends_on "glm" => :test
  depends_on "glslang" => :test

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "make", "install"
    end
    # required for tests
    prefix.install "samples"
    (include/"spirv_cross").install Dir["include/spirv_cross/*"]
  end

  test do
    cp_r Dir[prefix/"samples/cpp/*"], testpath
    inreplace "Makefile", "-I../../include", "-I#{include}"
    inreplace "Makefile", "../../spirv-cross", bin/"spirv-cross"
    inreplace "Makefile", "glslangValidator", Formula["glslang"].bin/"glslangValidator"

    # fix technically invalid shader code (#version should be first)
    # allows test to pass with newer glslangValidator
    before = <<~EOS
      // Copyright 2016-2021 The Khronos Group Inc.
      // SPDX-License-Identifier: Apache-2.0

      #version 310 es
    EOS
    after = <<~EOS
      #version 310 es
      // Copyright 2016-2021 The Khronos Group Inc.
      // SPDX-License-Identifier: Apache-2.0

    EOS
    (Dir["*.comp"]).each do |shader_file|
      inreplace shader_file, before, after
    end

    system "make", "all"
  end
end
