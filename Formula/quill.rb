class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v3.0.1.tar.gz"
  sha256 "c256325a354b77c517a8e14e5ed7f1218be5113a974e2190ef47b00cd4f045e4"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "108550d24829939ac5fca6bee9008f529dfd41075fa20b57963558ccd008fec6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca622bf3e9410b9451ebeca0d1c665a5fcaac4d056352e53e66ceef1e2dd79be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a06055d130fb0f37ed578ca976864fdfd3b145313d0c586bacd7418eca9e5db"
    sha256 cellar: :any_skip_relocation, ventura:        "4151a07fee4643640161532f9b41f1f8cbc2f628c8743e8caee4c9e8ab0e1e59"
    sha256 cellar: :any_skip_relocation, monterey:       "313575c71a07d4c660564cc53138444d772b96298fba016c2fedb063b58f5d87"
    sha256 cellar: :any_skip_relocation, big_sur:        "e6258d361c595d065a288ad2474001ad7ea7f8b45c261ef98471af2582364f17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a25aa4dfdad9c9bf272dd9013872d68ec99904aed0f77a0d631d5189184dfed0"
  end

  depends_on "cmake" => :build
  depends_on macos: :catalina

  fails_with gcc: "5"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include "quill/Quill.h"
      int main()
      {
        quill::start();
        std::shared_ptr< quill::Handler > file_handler = quill::file_handler("#{testpath}/basic-log.txt", "w");
        quill::Logger* logger = quill::create_logger("logger_bar", std::move(file_handler));
        LOG_INFO(logger, "Test");
      }
    EOS

    system ENV.cxx, "-std=c++17", "test.cpp", "-I#{include}", "-L#{lib}", "-lquill", "-o", "test", "-pthread"
    system "./test"
    assert_predicate testpath/"basic-log.txt", :exist?
    assert_match "Test", (testpath/"basic-log.txt").read
  end
end
