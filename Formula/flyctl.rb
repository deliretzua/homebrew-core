class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.360",
      revision: "79db81da31a54b98882f878c2446c1a9dbde195b"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8333cfbf6b781950732b8f7eb7e5a61c0f35f79faa8a4c659666038cae18794d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8333cfbf6b781950732b8f7eb7e5a61c0f35f79faa8a4c659666038cae18794d"
    sha256 cellar: :any_skip_relocation, monterey:       "3738cb4a2ca21c01ef5eebab7af7ff392875c7847c20e2c5244044d9d2a89807"
    sha256 cellar: :any_skip_relocation, big_sur:        "3738cb4a2ca21c01ef5eebab7af7ff392875c7847c20e2c5244044d9d2a89807"
    sha256 cellar: :any_skip_relocation, catalina:       "3738cb4a2ca21c01ef5eebab7af7ff392875c7847c20e2c5244044d9d2a89807"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fda787de6eace9dcd2afa7eb4f41b7a0e608904e590ac33002e78b243ba4e8d4"
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
