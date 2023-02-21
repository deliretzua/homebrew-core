class Hyperscan < Formula
  desc "High-performance regular expression matching library"
  homepage "https://www.hyperscan.io/"
  url "https://github.com/intel/hyperscan/archive/v5.4.1.tar.gz"
  sha256 "6798202350ecab5ebe5063fbbb6966c33d43197b39ce7ddfbca2e61ac5ecb54a"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 ventura:      "a4fc78fa4d26c64c84bab7368868e9e6cab11b095a50417d90170fa9f36336fc"
    sha256 cellar: :any,                 monterey:     "11b9e5d59354cb47e13696678ef1e8ae413140644b000f0482f2eb0f791d2bcf"
    sha256 cellar: :any,                 big_sur:      "70eb92530ab4a02c32b5e4696a38f2b37dbfcd98a982795f82ceec5f8345019e"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "7b96b0ff9caf5d6f7f201f5ae2916a110dd179828d096e19bb0b4326fd90db2e"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "ragel" => :build
  # Only supports x86 instructions and will fail to build on ARM.
  # See https://github.com/intel/hyperscan/issues/197
  depends_on arch: :x86_64
  depends_on "pcre"

  def install
    args = ["-DBUILD_STATIC_AND_SHARED=ON"]

    # Linux CI cannot guarantee AVX2 support needed to build fat runtime.
    args << "-DFAT_RUNTIME=OFF" if OS.linux?

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <hs/hs.h>
      int main()
      {
        printf("hyperscan v%s", hs_version());
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lhs", "-o", "test"
    system "./test"
  end
end
