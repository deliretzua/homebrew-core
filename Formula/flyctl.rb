class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.16",
      revision: "2b23fd76a0fff98d462e31b2e1f787dcb1244ce8"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa779dd8cb79416fa1b83c73c73946b9c911c67b97c0dda8e8b3474a19b8ed2a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa779dd8cb79416fa1b83c73c73946b9c911c67b97c0dda8e8b3474a19b8ed2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa779dd8cb79416fa1b83c73c73946b9c911c67b97c0dda8e8b3474a19b8ed2a"
    sha256 cellar: :any_skip_relocation, ventura:        "94fa4d27f1b2727d5c34f1d07884d92ba232fca118dbb2fe095313b7f1f1ed25"
    sha256 cellar: :any_skip_relocation, monterey:       "94fa4d27f1b2727d5c34f1d07884d92ba232fca118dbb2fe095313b7f1f1ed25"
    sha256 cellar: :any_skip_relocation, big_sur:        "94fa4d27f1b2727d5c34f1d07884d92ba232fca118dbb2fe095313b7f1f1ed25"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "20ee94cb460bdd143f227ffbde128b7313613cff153347995bd35f0a707f0e93"
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
