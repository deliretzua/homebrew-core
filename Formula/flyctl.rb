class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.22",
      revision: "c0149748becb904b80b207ccd69679ce9cd219d3"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "621e40b74d0c7ddd5b6ae12052d898fe9e45d054617d879089b0ec18f97a2485"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "621e40b74d0c7ddd5b6ae12052d898fe9e45d054617d879089b0ec18f97a2485"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "621e40b74d0c7ddd5b6ae12052d898fe9e45d054617d879089b0ec18f97a2485"
    sha256 cellar: :any_skip_relocation, ventura:        "3c0b61cb0bbd70826ab0d8fa43f6ab91b8638394e3a7ba12cef2700ce11c08c9"
    sha256 cellar: :any_skip_relocation, monterey:       "3c0b61cb0bbd70826ab0d8fa43f6ab91b8638394e3a7ba12cef2700ce11c08c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c0b61cb0bbd70826ab0d8fa43f6ab91b8638394e3a7ba12cef2700ce11c08c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b5002d42d7bfacd6e4469796f23523d840f82fab505258aaa73b6883f24efc1"
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
