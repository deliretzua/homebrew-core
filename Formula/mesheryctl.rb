class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.37",
      revision: "83a6e7ba14b2ef0a94693a3e9b273357cb5e6c50"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ea9051ed80f628c556b6e29d5d1023e594ef191354caea3ac1e7e05696301c09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ea9051ed80f628c556b6e29d5d1023e594ef191354caea3ac1e7e05696301c09"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ea9051ed80f628c556b6e29d5d1023e594ef191354caea3ac1e7e05696301c09"
    sha256 cellar: :any_skip_relocation, ventura:        "136658db564335bf46a4f53938cfea8d03ab70f8932645fb4e1d6fb780f0962e"
    sha256 cellar: :any_skip_relocation, monterey:       "136658db564335bf46a4f53938cfea8d03ab70f8932645fb4e1d6fb780f0962e"
    sha256 cellar: :any_skip_relocation, big_sur:        "136658db564335bf46a4f53938cfea8d03ab70f8932645fb4e1d6fb780f0962e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e8ca4eefcdb921e5f5c5af20057dfda665cca6b5a2bde555d4d2ef6a4434a2f9"
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
