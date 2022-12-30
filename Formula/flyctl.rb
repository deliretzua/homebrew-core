class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.442",
      revision: "e5a70d7975abc029e3b6e090067697220c2766cb"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "16198d01a051e5a2aae2b61f8d128bd0d7fb9e6636c7f4923134a29550769ecd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "16198d01a051e5a2aae2b61f8d128bd0d7fb9e6636c7f4923134a29550769ecd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "16198d01a051e5a2aae2b61f8d128bd0d7fb9e6636c7f4923134a29550769ecd"
    sha256 cellar: :any_skip_relocation, ventura:        "278430da19dc8be1a4fdde9b666e5002ea22fecd269ace2cc93233746296ac33"
    sha256 cellar: :any_skip_relocation, monterey:       "278430da19dc8be1a4fdde9b666e5002ea22fecd269ace2cc93233746296ac33"
    sha256 cellar: :any_skip_relocation, big_sur:        "278430da19dc8be1a4fdde9b666e5002ea22fecd269ace2cc93233746296ac33"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "270251c61e040c03cd3f4e892c378f19b96f8739b01351378ebe27ce5e694238"
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

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
