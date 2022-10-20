class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.17",
      revision: "106d931c93c05066b82c268286023b5385304e4a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4db9980d409481700b54773346fa0d569d8bec4b5110da8f0c5776577454a3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4db9980d409481700b54773346fa0d569d8bec4b5110da8f0c5776577454a3e"
    sha256 cellar: :any_skip_relocation, monterey:       "f668aa9c185795904b85e8905db4092f837efe3813e21692654e35fc1c61d984"
    sha256 cellar: :any_skip_relocation, big_sur:        "f668aa9c185795904b85e8905db4092f837efe3813e21692654e35fc1c61d984"
    sha256 cellar: :any_skip_relocation, catalina:       "f668aa9c185795904b85e8905db4092f837efe3813e21692654e35fc1c61d984"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3033c46fd819d56e4b9af06772c69fc85bdd771f7d45669ee8604966f860b923"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
