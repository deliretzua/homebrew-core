class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.4",
      revision: "d2288a872b138e36912caca39631ae9a1b03098e"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9828629d602b46e5b54bca7af65c715d3393b698139a778797ff990e053419f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9828629d602b46e5b54bca7af65c715d3393b698139a778797ff990e053419f6"
    sha256 cellar: :any_skip_relocation, monterey:       "646aff69fd4bf564764cd44b4b74622a022cf3527f7f9105693a93625b93a558"
    sha256 cellar: :any_skip_relocation, big_sur:        "646aff69fd4bf564764cd44b4b74622a022cf3527f7f9105693a93625b93a558"
    sha256 cellar: :any_skip_relocation, catalina:       "646aff69fd4bf564764cd44b4b74622a022cf3527f7f9105693a93625b93a558"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51c08b0a11abad2142e5843799d6e216a4b73da03ae76b8e5c8c16676fa055cf"
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

    output = Utils.safe_popen_read("#{bin}/mesheryctl", "completion", "bash")
    (bash_completion/"mesheryctl").write output

    output = Utils.safe_popen_read("#{bin}/mesheryctl", "completion", "zsh")
    (zsh_completion/"_mesheryctl").write output

    output = Utils.safe_popen_read("#{bin}/mesheryctl", "completion", "fish")
    (fish_completion/"mesheryctl.fish").write output
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
