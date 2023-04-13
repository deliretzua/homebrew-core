class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.79",
      revision: "2fae5967c79c047c463bfd045e0b1128de5f4d25"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb6c52441f780165e87f59d1c85cac3479317da788e8572abb79ebc4715a1d91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7e2d0f863e8c10bfde7b5041e920fb99d35ee2d550602a1352374a359e1ec24f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e2d0f863e8c10bfde7b5041e920fb99d35ee2d550602a1352374a359e1ec24f"
    sha256 cellar: :any_skip_relocation, ventura:        "bc507637b08515bab7e4c993059299af42633e01b00f71c4b881a3c5c5691433"
    sha256 cellar: :any_skip_relocation, monterey:       "bc507637b08515bab7e4c993059299af42633e01b00f71c4b881a3c5c5691433"
    sha256 cellar: :any_skip_relocation, big_sur:        "bc507637b08515bab7e4c993059299af42633e01b00f71c4b881a3c5c5691433"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53db600bc83fbd1c5ec178a839aeee2d5b980b32a3be2a8fac61fbf6e7fa421f"
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
