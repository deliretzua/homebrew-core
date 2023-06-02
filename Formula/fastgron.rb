class Fastgron < Formula
  desc "High-performance JSON to GRON converter"
  homepage "https://github.com/adamritter/fastgron"
  url "https://github.com/adamritter/fastgron/archive/v0.4.13.tar.gz"
  sha256 "8a7c48c1f96a97662aaf38e623655a85d17561740892b671fa6c29d1b7a5b27d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a17223e9fea0a1e0a5001d9fa4e2ea495ba029d45bf2f63dde3365e3e32702ba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ba6f1d951b5eb4285cf05f575603f92ea40bba450cb5b27f42bb63607bec9ee"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7de6c68988eb879b4c47b01f524ce897bd0d3be99543071459a0a3e4dc18593"
    sha256 cellar: :any_skip_relocation, ventura:        "0b6466cc791fd30b957e78bc14849a4ab82efc1aedb3b43c7992a50aaf96c832"
    sha256 cellar: :any_skip_relocation, monterey:       "457219bc56f3d8ec02adac19f9d5e418a0a16130d5c1c1227542562dc8125697"
    sha256 cellar: :any_skip_relocation, big_sur:        "2c52b03b5c18d89888ae1b26176b1df4726885c3f8ef3862b66d8fa0edefa850"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90db85da1a94d94ad5661d853d795b0885d3852c2da37781c5fa2e0d56c4befd"
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
