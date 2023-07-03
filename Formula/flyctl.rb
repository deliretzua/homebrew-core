class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.47",
      revision: "c39ca26fffe52f54832e94c8767995d2ba3a41c3"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4990a540ebf120dd8de75d0735a4120a3cf752296baf944d1054175d7377bb7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4990a540ebf120dd8de75d0735a4120a3cf752296baf944d1054175d7377bb7d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4990a540ebf120dd8de75d0735a4120a3cf752296baf944d1054175d7377bb7d"
    sha256 cellar: :any_skip_relocation, ventura:        "125a0caea386a96a32b3acd2b3e6944e0ea4e3249b2e45e59e75dddec0da4397"
    sha256 cellar: :any_skip_relocation, monterey:       "125a0caea386a96a32b3acd2b3e6944e0ea4e3249b2e45e59e75dddec0da4397"
    sha256 cellar: :any_skip_relocation, big_sur:        "125a0caea386a96a32b3acd2b3e6944e0ea4e3249b2e45e59e75dddec0da4397"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0084c67aafa8c53325cd844b29c86180169a0cc13be73206ec0379055fa79905"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error: No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
