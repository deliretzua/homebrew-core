class LaceworkCli < Formula
  desc "CLI for managing Lacework"
  homepage "https://docs.lacework.com/cli"
  url "https://github.com/lacework/go-sdk.git",
      tag:      "v1.27.2",
      revision: "bc2987f7419b1b6d5e9c9c78c52025bbb6cdf731"
  license "Apache-2.0"
  head "https://github.com/lacework/go-sdk.git", branch: "main"

  # There can be a notable gap between when a version is tagged and a
  # corresponding release is created, so we check the "latest" release instead
  # of the Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd43643a96692e8da8b492a5ca8ff6a61ebf894d7f86543d093fa9277d56be44"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1c8f3056ebb791786aef2c08cc01bc7fb2c57b283e04a75e4e15c41e0d172298"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6262c5f3c2e851891626f6958cc8f7427308d7676626a4ba5003dfb6953ef50"
    sha256 cellar: :any_skip_relocation, ventura:        "c39d8466cfe71bccd208b49e88bf4c7e20dff52e484e2ad4b1aee2b0c30b0cc9"
    sha256 cellar: :any_skip_relocation, monterey:       "14b95349578d5d5785d389dd8ab0a389586621d397ef218509e626dadf64dcca"
    sha256 cellar: :any_skip_relocation, big_sur:        "e266f5973319e1438c0af0e74a5b285296b7310ecd7432a460e4047f3f3ebfb8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "917221d4ca4765e27277fa7a18f916c6a947d37a99d0d04cbf8e98c032440946"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/lacework/go-sdk/cli/cmd.Version=#{version}
      -X github.com/lacework/go-sdk/cli/cmd.GitSHA=#{Utils.git_head}
      -X github.com/lacework/go-sdk/cli/cmd.BuildTime=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(output: bin/"lacework", ldflags: ldflags), "./cli"

    generate_completions_from_executable(bin/"lacework", "completion", base_name: "lacework")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lacework version")

    output = shell_output("#{bin}/lacework configure list 2>&1", 1)
    assert_match "ERROR unable to load profiles. No configuration file found.", output
  end
end
