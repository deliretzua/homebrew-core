class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.26",
      revision: "f880141535db104067f4aad4dab8127890dfa07a"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "512f34b21e4b313ad5936f99522e6278c8ef73950a35b40eaf411d9456ededd1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "512f34b21e4b313ad5936f99522e6278c8ef73950a35b40eaf411d9456ededd1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "512f34b21e4b313ad5936f99522e6278c8ef73950a35b40eaf411d9456ededd1"
    sha256 cellar: :any_skip_relocation, monterey:       "622fa5df9243a449e4bd7022a72dfc3190909c11fbfa41b08e04193eb99c4cfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "622fa5df9243a449e4bd7022a72dfc3190909c11fbfa41b08e04193eb99c4cfb"
    sha256 cellar: :any_skip_relocation, catalina:       "622fa5df9243a449e4bd7022a72dfc3190909c11fbfa41b08e04193eb99c4cfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3d4564374f5d8c6d28cd3a4cae263cf37ef20d47357f955717df352339ad010b"
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
