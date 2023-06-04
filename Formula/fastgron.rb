class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://github.com/adamritter/fastgron/archive/v0.5.0.tar.gz"
  sha256 "6a53c65fe39e6e2b01b282a77f9c149b9ef3e89e300021b8d1529f39448a45ae"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "940a9e2c4f2354d6baaa93408ecea890c8108dcf834fd01df50007b616d20c79"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b8eb70fc9dfa6182fdb4f0d8b6f0e85ba767b16a48d131d8f497bacfd756ea2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68fd50340c824b6fb47040cc610cc8de9476f31bf591cdff8153e7dc86b631d8"
    sha256 cellar: :any_skip_relocation, ventura:        "cda0eed2c1f33d4d35a670873df4efdc0613871afb8a2039226175eaa05dceff"
    sha256 cellar: :any_skip_relocation, monterey:       "cf91fc8e7235cb7b047a898cdaecfe9c188df9797fe753c990d89be7fe9d07c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c9c7d7479cd05d82ea0c1fd501d20dc7758496f0f683e921ca695257e145f1b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7bfac39a4ad52eb84e9cf1c0ec8cfffa98605eb23d6bd0d170347a1c676f63ea"
  end

  depends_on "cmake" => :build

  uses_from_macos "curl"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected = <<~EOS
      json = []
      json[0] = 3
      json[1] = 4
      json[2] = 5
    EOS
    assert_equal expected, pipe_output(bin/"fastgron", "[3,4,5]")

    assert_match version.to_s, shell_output(bin/"fastgron --version 2>&1")
  end
end
