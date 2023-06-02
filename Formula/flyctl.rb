class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.26",
      revision: "4f0cc0dda12801e566e460d1c47c60815052fd89"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec1b640f9808d68d8a0e9c1e1f270676a410ecb306316acdecfab2d4a28ac523"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec1b640f9808d68d8a0e9c1e1f270676a410ecb306316acdecfab2d4a28ac523"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec1b640f9808d68d8a0e9c1e1f270676a410ecb306316acdecfab2d4a28ac523"
    sha256 cellar: :any_skip_relocation, ventura:        "236da00d42518209929f56ccf54ed2a47c3893ce85d39d8ffacfb3eb94dc903d"
    sha256 cellar: :any_skip_relocation, monterey:       "236da00d42518209929f56ccf54ed2a47c3893ce85d39d8ffacfb3eb94dc903d"
    sha256 cellar: :any_skip_relocation, big_sur:        "236da00d42518209929f56ccf54ed2a47c3893ce85d39d8ffacfb3eb94dc903d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b44c28994cad5ed3218a9ada9d7db8c673f681700f1b57fc319f87421a2cac57"
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
