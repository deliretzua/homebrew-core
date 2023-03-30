class AliyunCli < Formula
  desc "Universal Command-Line Interface for Alibaba Cloud"
  homepage "https://github.com/aliyun/aliyun-cli"
  url "https://github.com/aliyun/aliyun-cli.git",
      tag:      "v3.0.160",
      revision: "b1a01235d76fb3c3fa636ee9d3f7281c3a91bafc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a1c976f6ea94c8613a4eb83b718ae74db326016dd6540a21eeb3785bef80e4fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a1c976f6ea94c8613a4eb83b718ae74db326016dd6540a21eeb3785bef80e4fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1c976f6ea94c8613a4eb83b718ae74db326016dd6540a21eeb3785bef80e4fc"
    sha256 cellar: :any_skip_relocation, ventura:        "18f4cb4b5323019e63394fa7a08b268d606aee364b8db06f21bb9fadba1d5fd2"
    sha256 cellar: :any_skip_relocation, monterey:       "18f4cb4b5323019e63394fa7a08b268d606aee364b8db06f21bb9fadba1d5fd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "18f4cb4b5323019e63394fa7a08b268d606aee364b8db06f21bb9fadba1d5fd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d6513b27f3f0e73097309bbeb940a359824761d325fb75cea10a88c3bfab55c"
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
