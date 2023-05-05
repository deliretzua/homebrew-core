class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.554",
      revision: "aa9b9ad3f3ed83e7df85c9b423bee6558d0e4389"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd3f5c92edaabf707cd43ca6f138883c7b85e8a7b8cbcb679690b715c8199a91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd3f5c92edaabf707cd43ca6f138883c7b85e8a7b8cbcb679690b715c8199a91"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fd3f5c92edaabf707cd43ca6f138883c7b85e8a7b8cbcb679690b715c8199a91"
    sha256 cellar: :any_skip_relocation, ventura:        "05c8cff4c537040e42dbcb67142cbb80d4d497616a0b70a3802fa58d82c41bdc"
    sha256 cellar: :any_skip_relocation, monterey:       "05c8cff4c537040e42dbcb67142cbb80d4d497616a0b70a3802fa58d82c41bdc"
    sha256 cellar: :any_skip_relocation, big_sur:        "05c8cff4c537040e42dbcb67142cbb80d4d497616a0b70a3802fa58d82c41bdc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6653bd0c1b7a7b0e898eb2b462ffcb97082ae6dcddcd6d64d42a578995555da"
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
