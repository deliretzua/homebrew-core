class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.96",
      revision: "57e5a3c14859d83eb49fb22a4010f318fd1ff999"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "adbbfa88826ed0fbf62d37ade99b3304ac24df93abc948128362ceb4963b1f53"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "adbbfa88826ed0fbf62d37ade99b3304ac24df93abc948128362ceb4963b1f53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "adbbfa88826ed0fbf62d37ade99b3304ac24df93abc948128362ceb4963b1f53"
    sha256 cellar: :any_skip_relocation, ventura:        "9ad8f83fc9a02a642f4434c3e399a601dc6768e1de3606fd8eb409e0bcad005c"
    sha256 cellar: :any_skip_relocation, monterey:       "9ad8f83fc9a02a642f4434c3e399a601dc6768e1de3606fd8eb409e0bcad005c"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ad8f83fc9a02a642f4434c3e399a601dc6768e1de3606fd8eb409e0bcad005c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c2f238e4c2c95aefd0649a524310106a688101b4510a6f9d404045909a9ba6c"
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
