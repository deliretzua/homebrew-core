class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.103",
      revision: "40368c484fa39b437852980e6f169bb3aee47d8f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ca22329ccb684655cdd3946e85f31c413b78a689e8e04bbce83188d986c3f7bd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ca22329ccb684655cdd3946e85f31c413b78a689e8e04bbce83188d986c3f7bd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ca22329ccb684655cdd3946e85f31c413b78a689e8e04bbce83188d986c3f7bd"
    sha256 cellar: :any_skip_relocation, ventura:        "8f898d16c8dad9b033e699d3fed9a36b3dfd393e1cca9895f1e04e76a7364e0e"
    sha256 cellar: :any_skip_relocation, monterey:       "8f898d16c8dad9b033e699d3fed9a36b3dfd393e1cca9895f1e04e76a7364e0e"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f898d16c8dad9b033e699d3fed9a36b3dfd393e1cca9895f1e04e76a7364e0e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eabfe102a72a344074789f52cb2aa88d7973567dd8228fb6b4917715b3932372"
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
