class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.464",
      revision: "f9840dd8a1cd25ba3ada1ef5fee2db563d529406"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5b9b22efe028a07db9975be2900a8a36aafd04ec1ea44de868b8edf7a7b072fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5b9b22efe028a07db9975be2900a8a36aafd04ec1ea44de868b8edf7a7b072fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5b9b22efe028a07db9975be2900a8a36aafd04ec1ea44de868b8edf7a7b072fc"
    sha256 cellar: :any_skip_relocation, ventura:        "aa01474984bf86e84a5cab16494d8b8b72cb2f3fa48c680eabf441944822f795"
    sha256 cellar: :any_skip_relocation, monterey:       "aa01474984bf86e84a5cab16494d8b8b72cb2f3fa48c680eabf441944822f795"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa01474984bf86e84a5cab16494d8b8b72cb2f3fa48c680eabf441944822f795"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9a316b56812d045137435806e9979c9646897823ec3bca703576507bbc08d36"
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
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
