class Vvenc < Formula
  desc "Fraunhofer Versatile Video Encoder"
  homepage "https://github.com/fraunhoferhhi/vvenc"
  url "https://github.com/fraunhoferhhi/vvenc/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "119970f1e00667045eb12775db10611fc04f9158348144913c9e233f98664714"
  license "BSD-3-Clause-Clear"
  head "https://github.com/fraunhoferhhi/vvenc.git", branch: "master"

  depends_on "cmake" => :build

  resource("test_video") do
    url "https://archive.org/download/test_bunny_202304/test_bunny.yuv"
    sha256 "6c7e90db57f5097d05d735757d72ef2ef4d5a3c0da562706fd9cfa669535e797"
  end

  def install
    system "cmake", "-S", ".", "-B", "build",
           "-DVVENC_INSTALL_FULLFEATURE_APP=1",
           "-DBUILD_SHARED_LIBS=1",
           *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    resource("test_video").stage testpath
    system bin/"vvencapp",
           "-i", testpath/"test_bunny.yuv",
           "-s", "360x640",
           "--fps", "60/1",
           "--format", "yuv420_10",
           "--hdr", "hdr10_2020",
           "-o", testpath/"test_bunny.vvc"
    assert_predicate testpath/"test_bunny.vvc", :exist?
  end
end
