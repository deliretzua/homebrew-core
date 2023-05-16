class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.6",
      revision: "da96e6137f55f8fdcf26aa3d3b547c89c2958a2c"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1cbfda3a87d0f9ad1f0cc5fa4b8be785f287f614ae3d2d598a8d7a336c64a638"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1cbfda3a87d0f9ad1f0cc5fa4b8be785f287f614ae3d2d598a8d7a336c64a638"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1cbfda3a87d0f9ad1f0cc5fa4b8be785f287f614ae3d2d598a8d7a336c64a638"
    sha256 cellar: :any_skip_relocation, ventura:        "3aca0dbfec01935555ae8f1689018d34ef27fc8bfa9d5b48be4a737511d73b72"
    sha256 cellar: :any_skip_relocation, monterey:       "3aca0dbfec01935555ae8f1689018d34ef27fc8bfa9d5b48be4a737511d73b72"
    sha256 cellar: :any_skip_relocation, big_sur:        "3aca0dbfec01935555ae8f1689018d34ef27fc8bfa9d5b48be4a737511d73b72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "371289219026e1e8926dae704c4591d91e5cc9e09ff41d8ab578395e741cbf7b"
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
