class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.518",
      revision: "5fcff9cebb9fd25b526312842152d271b2c85b74"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9b8dffec188747b0e12d509deedc1ed6a7488952c5666723bef3051cb5b264a9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b8dffec188747b0e12d509deedc1ed6a7488952c5666723bef3051cb5b264a9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b8dffec188747b0e12d509deedc1ed6a7488952c5666723bef3051cb5b264a9"
    sha256 cellar: :any_skip_relocation, ventura:        "7e386d17404c7d9df4478e6abda108385d21e943f74580a2bcaebd0df6e70415"
    sha256 cellar: :any_skip_relocation, monterey:       "7e386d17404c7d9df4478e6abda108385d21e943f74580a2bcaebd0df6e70415"
    sha256 cellar: :any_skip_relocation, big_sur:        "7e386d17404c7d9df4478e6abda108385d21e943f74580a2bcaebd0df6e70415"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "975de5f283104fb9157fb42b2bd49661e0d9fbc7f8b3f2b81cae6674b4093a69"
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
