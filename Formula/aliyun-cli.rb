class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.165",
      revision: "67ab4ebd377d95a01eaeeaf578601a06c5b84dbd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5cf0b654cffe5cadea57fbf652b49e0f59ba0f0181b518e0935606096667ba7c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5cf0b654cffe5cadea57fbf652b49e0f59ba0f0181b518e0935606096667ba7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5cf0b654cffe5cadea57fbf652b49e0f59ba0f0181b518e0935606096667ba7c"
    sha256 cellar: :any_skip_relocation, ventura:        "38c327e0a2032355ad5edda9e90166139e3c9557bd0702a8de375afb52b678fb"
    sha256 cellar: :any_skip_relocation, monterey:       "38c327e0a2032355ad5edda9e90166139e3c9557bd0702a8de375afb52b678fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "38c327e0a2032355ad5edda9e90166139e3c9557bd0702a8de375afb52b678fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fa44a8100b2aa0ecb46a367d884df5463f9af213c0663efbf3656ffc4dcb4a78"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/aliyun/aliyun-cli/cli.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"aliyun", ldflags: ldflags), "main/main.go"
  end

  test do
    version_out = shell_output("#{bin}/aliyun version")
    assert_match version.to_s, version_out

    help_out = shell_output("#{bin}/aliyun --help")
    assert_match "Alibaba Cloud Command Line Interface Version #{version}", help_out
    assert_match "", help_out
    assert_match "Usage:", help_out
    assert_match "aliyun <product> <operation> [--parameter1 value1 --parameter2 value2 ...]", help_out

    oss_out = shell_output("#{bin}/aliyun oss")
    assert_match "Object Storage Service", oss_out
    assert_match "aliyun oss [command] [args...] [options...]", oss_out
  end
end
