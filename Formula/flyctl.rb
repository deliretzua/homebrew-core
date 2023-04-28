class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.547",
      revision: "9f1e16ae18d98da3599b98bb494ddde7a8f93a92"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3656103d10dd477da761f344bb97f6d1877fc3d6069db7f0136cbd4d12bd794f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3656103d10dd477da761f344bb97f6d1877fc3d6069db7f0136cbd4d12bd794f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3656103d10dd477da761f344bb97f6d1877fc3d6069db7f0136cbd4d12bd794f"
    sha256 cellar: :any_skip_relocation, ventura:        "0ea5ccee6cf97242e1178b965061b088b0538b215b0b705d8141d9de9ab43af7"
    sha256 cellar: :any_skip_relocation, monterey:       "0ea5ccee6cf97242e1178b965061b088b0538b215b0b705d8141d9de9ab43af7"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ea5ccee6cf97242e1178b965061b088b0538b215b0b705d8141d9de9ab43af7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b8f68718682ec16f83a17a8d80b83b937995583a59b476a82a8908ddf15adde6"
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
