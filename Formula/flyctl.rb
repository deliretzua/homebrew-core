class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.19",
      revision: "4a8984cfdbf45a4bffea06fc16b02440d106456c"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "223ebab60277472e988ac4f05adbc14b631ca21e9269eda644d9520f61afa43b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "223ebab60277472e988ac4f05adbc14b631ca21e9269eda644d9520f61afa43b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "223ebab60277472e988ac4f05adbc14b631ca21e9269eda644d9520f61afa43b"
    sha256 cellar: :any_skip_relocation, ventura:        "2f5ec357f4b3210d4d6a763f95fa0008f70d9d1ca50d294be62568e14846404e"
    sha256 cellar: :any_skip_relocation, monterey:       "2f5ec357f4b3210d4d6a763f95fa0008f70d9d1ca50d294be62568e14846404e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2f5ec357f4b3210d4d6a763f95fa0008f70d9d1ca50d294be62568e14846404e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "01ab6ca5b0f229a88df7c10e225e24f6eee2305cea19539fa6e8d95ba8ecda6c"
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
