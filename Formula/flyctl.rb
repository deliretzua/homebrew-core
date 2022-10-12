class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.411",
      revision: "bf07bc29942b3791a71cb5d94c943c0ef11e1f81"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "737170aff72dbc9cb0ef031b8a74083375b506ec120143871cf58640afaf4478"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "737170aff72dbc9cb0ef031b8a74083375b506ec120143871cf58640afaf4478"
    sha256 cellar: :any_skip_relocation, monterey:       "a6b55c93178121ed4752a0ae2aec1760fffbadd6914a359b2c216b9b32fe561f"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6b55c93178121ed4752a0ae2aec1760fffbadd6914a359b2c216b9b32fe561f"
    sha256 cellar: :any_skip_relocation, catalina:       "a6b55c93178121ed4752a0ae2aec1760fffbadd6914a359b2c216b9b32fe561f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7601dd731d5d2762d27b6fabdd82466c169828dcb2e6a9c2350474daed82295a"
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

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
