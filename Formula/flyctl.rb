class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.362",
      revision: "0023255c11083600341572016a0952f842802161"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "425f320a3656b4e29126f9583d8da2835c2cb421bc5402c1d2af75314e70649e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "425f320a3656b4e29126f9583d8da2835c2cb421bc5402c1d2af75314e70649e"
    sha256 cellar: :any_skip_relocation, monterey:       "ee384d933c35a8314dbbf009467d42e1577fec91604a740a89ad9ef5242ef8db"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee384d933c35a8314dbbf009467d42e1577fec91604a740a89ad9ef5242ef8db"
    sha256 cellar: :any_skip_relocation, catalina:       "ee384d933c35a8314dbbf009467d42e1577fec91604a740a89ad9ef5242ef8db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddf637ad3873d26ed5caf607abafe401b2bb12316406ad7744d74ab810871f61"
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
