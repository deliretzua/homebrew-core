class Libzen < Formula
  desc "Shared library for libmediainfo"
  homepage "https://github.com/MediaArea/ZenLib"
  url "https://mediaarea.net/download/source/libzen/0.4.41/libzen_0.4.41.tar.bz2"
  sha256 "eb237d7d3dca6dc6ba068719420a27de0934a783ccaeb2867562b35af3901e2d"
  license "Zlib"
  head "https://github.com/MediaArea/ZenLib.git", branch: "master"

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", "Project/CMake", "-B", "build", "-DBUILD_SHARED_LIBS=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <ZenLib/Ztring.h>
      #include <iostream>
      int main() {
        ZenLib::Ztring myString = ZenLib::Ztring().From_UTF8("Hello, ZenLib!");
        std::cout << myString.To_UTF8() << std::endl;
        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", "test.cc", "-I#{include}", "-L#{lib}", "-lzen", "-o", "test"
    system "./test"
  end
end
