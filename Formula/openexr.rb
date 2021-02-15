class Openexr < Formula
  desc "High dynamic-range image file format"
  homepage "https://www.openexr.com/"
  # NOTE: Please keep these values in sync with ilmbase.rb when updating.
  url "https://github.com/openexr/openexr/archive/v2.5.5.tar.gz"
  sha256 "59e98361cb31456a9634378d0f653a2b9554b8900f233450f2396ff495ea76b3"
  license "BSD-3-Clause"

  bottle do
    sha256 arm64_big_sur: "f23f4e7523ae27fbc1885360cc99dc60b35cca395b6f8f46d45c1d7c275f0e90"
    sha256 big_sur:       "eb633be8c992dbfa2bb4406cd397abfe16aad0bf75f252e02e8ff7d720a9f93c"
    sha256 catalina:      "8f146ff213eda72a32613ba36649a865848786c0e843fc6a39e58bdeafebcb31"
    sha256 mojave:        "b9f0b513b60da938425fd93805835cfaaa916db9406687a7aa11112ec152a6f7"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "ilmbase"

  uses_from_macos "zlib"

  resource "exr" do
    url "https://github.com/openexr/openexr-images/raw/master/TestImages/AllHalfValues.exr"
    sha256 "eede573a0b59b79f21de15ee9d3b7649d58d8f2a8e7787ea34f192db3b3c84a4"
  end

  def install
    cd "OpenEXR" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    resource("exr").stage do
      system bin/"exrheader", "AllHalfValues.exr"
    end
  end
end
