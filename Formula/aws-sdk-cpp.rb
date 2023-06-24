class AwsSdkCpp < Formula
  desc "AWS SDK for C++"
  homepage "https://github.com/aws/aws-sdk-cpp"
  url "https://github.com/aws/aws-sdk-cpp.git",
      tag:      "1.11.107",
      revision: "fa0b62570cd0528b4ff9ae50351741036c8c7dda"
  license "Apache-2.0"
  head "https://github.com/aws/aws-sdk-cpp.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4e5c907818ad4bc8fc636dc16e647f4b70f1b101d5c9cf1d3bb7ea55889ef562"
    sha256 cellar: :any,                 arm64_monterey: "e83015306cd30fb39793078dcbca9beac5de9f9550a4ea407fa0c9c085042226"
    sha256 cellar: :any,                 arm64_big_sur:  "61fc147f108b40892bf8516f3eef21c49465f4b2eb64a9df56a49d742d893b80"
    sha256 cellar: :any,                 ventura:        "e4e4f1e79a5c161d754b65f0174b887c56d27743c543610f85b3ef914f68de11"
    sha256 cellar: :any,                 monterey:       "36c3c8c513ffc09cc6bb177a2f051d671a89daf44938c50b73bf045992c6c518"
    sha256 cellar: :any,                 big_sur:        "90013b83c9b1c84d3c3509c67733f564d257e2907b52e9c9480ecf28ed9d63bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a0260e7ef0fee7dd0ba58c4fcd88d5ce00b3a9f422e477afb045730ac439bc8"
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
