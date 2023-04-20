class Quill < Formula
  desc "C++17 Asynchronous Low Latency Logging Library"
  homepage "https://github.com/odygrd/quill"
  url "https://github.com/odygrd/quill/archive/refs/tags/v2.8.0.tar.gz"
  sha256 "0461a6c314e3d882f3b9ada487ef1bf558925272509ee41a9fd25f7776db6075"
  license "MIT"
  head "https://github.com/odygrd/quill.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec474fcf3f8632d844e49d18cd75832a0216770a6fd31c300a9e7210ca963fd0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b443b9da056a57e35b6282292098759bb61f4ab6e5f183f04df4cfe55e01b81"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4abd2e2295a479e626e0cdbdff23aab77be58e345cff6a18b4f82a443805d56"
    sha256 cellar: :any_skip_relocation, ventura:        "8f17a6fd1271d5a1b93d4d64d5c0a20c9d20fd58319c7c3384b285f3ea7bdd8a"
    sha256 cellar: :any_skip_relocation, monterey:       "bf441cdd5e415b432d1df767461becc228194bd4f2d23b4fd6735658b9fb92f9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5769ce2aa6deedea4bf6c4935f84933d408b18d66d739f2173ab5eb5cf877cf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "326dd6450340908ed3b45e28f86f8d9fe4dcfed6c9dbebafba01e9fe32f9c1cd"
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
