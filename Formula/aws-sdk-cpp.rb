class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.109",
      revision: "4880fa91f67a8ca55b1c126efe02b8a2facefe55"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e102085aa3fc21385259c577a5a216940ccc02ce418db10f1b05e006a1be4954"
    sha256 cellar: :any,                 arm64_monterey: "36dfa13820bb207e5b167a6a3828ac42c5411892304232da4f03869a2e46b4ef"
    sha256 cellar: :any,                 arm64_big_sur:  "7a1cf012c6817a91f5a1995e7f14c60accfa611839ef535f8739eacd83bcf7d5"
    sha256 cellar: :any,                 ventura:        "61fecc068435473143d2fac4e86ead3ce77b19ad8ff4d6e3e2a576abcb9f2f01"
    sha256 cellar: :any,                 monterey:       "32e5e89fac322bd3b2ef7e33feccf3d0b146051e83237ab895c4bd57563cc3da"
    sha256 cellar: :any,                 big_sur:        "70eb7fa7622915e103c065f4bda85b92eca58e17251b22c7d944b93d4ca95226"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "69fdd05d30155b6d8d0c1ada1daaefcfa6ab9db1c4517e68c9933876fc3c942e"
  end

  depends_on "cmake" => :build
  uses_from_macos "curl"

  fails_with gcc: "5"

  def install
    ENV.append "LDFLAGS", "-Wl,-rpath,#{rpath}"
    # Avoid OOM failure on Github runner
    ENV.deparallelize if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DENABLE_TESTING=OFF"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    lib.install Dir[lib/"mac/Release/*"].select { |f| File.file? f }
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <aws/core/Version.h>
      #include <iostream>

      int main() {
          std::cout << Aws::Version::GetVersionString() << std::endl;
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++11", "test.cpp", "-L#{lib}", "-laws-cpp-sdk-core", "-o", "test"
    system "./test"
  end
end
