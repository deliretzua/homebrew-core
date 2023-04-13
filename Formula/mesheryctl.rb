class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.79",
      revision: "2fae5967c79c047c463bfd045e0b1128de5f4d25"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7030fe984ccb818a34dbcdbfb77ddedf2bcb49f1c8c6673997fb54841242b660"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1e8d039522d38428fa1cb744ff603ee62f6b250865df16d8ccb14affff7b30c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7030fe984ccb818a34dbcdbfb77ddedf2bcb49f1c8c6673997fb54841242b660"
    sha256 cellar: :any_skip_relocation, ventura:        "ef9b3f67890e3730237c30aa5c0e16561941de70e1e63039c131164874129b42"
    sha256 cellar: :any_skip_relocation, monterey:       "544fe99f53fb676837f260ed157a961e0c9bb88f6b1d9c3b49a4b93d319cbb33"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef9b3f67890e3730237c30aa5c0e16561941de70e1e63039c131164874129b42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "529cb43dfbf7a1b5289097f560da3f218b9ddf31a38d9d08206b772a041ca71c"
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
