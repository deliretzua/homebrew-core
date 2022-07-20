class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.355",
      revision: "691004cffa5394f21dd6823c7537e35e3d4db8ee"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4fabf767e0384b98eb16674454977bc2ad86bc0672c88d78ba175f845fc2dfa4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4fabf767e0384b98eb16674454977bc2ad86bc0672c88d78ba175f845fc2dfa4"
    sha256 cellar: :any_skip_relocation, monterey:       "7eb75e6f9fde5e6853f01c833e48eeac437ebbf49845cd428e0867ab4c60ff2c"
    sha256 cellar: :any_skip_relocation, big_sur:        "7eb75e6f9fde5e6853f01c833e48eeac437ebbf49845cd428e0867ab4c60ff2c"
    sha256 cellar: :any_skip_relocation, catalina:       "7eb75e6f9fde5e6853f01c833e48eeac437ebbf49845cd428e0867ab4c60ff2c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10fae3d9713ef3f2ccea1767007ae077ddeebeca30ed563406561b8c70fe3dd1"
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
