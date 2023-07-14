class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.57",
      revision: "c3b6f4341184583f3a65d38985595dadfb41b730"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a315a313cbd3b3689ac18676f4a00430cc05b279132e60f178c74b15608fd94e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a315a313cbd3b3689ac18676f4a00430cc05b279132e60f178c74b15608fd94e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a315a313cbd3b3689ac18676f4a00430cc05b279132e60f178c74b15608fd94e"
    sha256 cellar: :any_skip_relocation, ventura:        "2daad8d3bad53a87dc02855929ca386f1153bca8bc2f572631234e7196afdd32"
    sha256 cellar: :any_skip_relocation, monterey:       "2daad8d3bad53a87dc02855929ca386f1153bca8bc2f572631234e7196afdd32"
    sha256 cellar: :any_skip_relocation, big_sur:        "2daad8d3bad53a87dc02855929ca386f1153bca8bc2f572631234e7196afdd32"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3fecf1f886e5b64ba46c5f74a84616d95162565e1b967621dad50058a22b3bfa"
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
