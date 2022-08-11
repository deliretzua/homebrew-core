class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.370",
      revision: "1e6c3ed57ac23ee1a6299d18bef83b960c18b529"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1dce6c4379999fbe036ba9075d9f58b49867bdffc6e5092927115359dbae7655"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1dce6c4379999fbe036ba9075d9f58b49867bdffc6e5092927115359dbae7655"
    sha256 cellar: :any_skip_relocation, monterey:       "ea9567b2245a5468b063dd3f42ee1824044cfa0050458e6d645152a3b318eb8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea9567b2245a5468b063dd3f42ee1824044cfa0050458e6d645152a3b318eb8d"
    sha256 cellar: :any_skip_relocation, catalina:       "ea9567b2245a5468b063dd3f42ee1824044cfa0050458e6d645152a3b318eb8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "660d744fa02b2dbf02e229ae5b60e77d08d1e10a5f2460bf8fb835650145e339"
  end

  # Required latest gvisor.dev/gvisor/pkg/gohacks
  # Try to switch to the latest go on the next release
  depends_on "go@1.18" => :build

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

    bash_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "bash")
    (bash_completion/"flyctl").write bash_output
    zsh_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "zsh")
    (zsh_completion/"_flyctl").write zsh_output
    fish_output = Utils.safe_popen_read("#{bin}/flyctl", "completion", "fish")
    (fish_completion/"flyctl.fish").write fish_output
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
