class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.56",
      revision: "7981f99ff550f66def5bbd9374db3d413310954f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "481497a4b6508b34f2745f631e6eb7222ce1c36fb3b76f0dd2e02e959439db49"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "481497a4b6508b34f2745f631e6eb7222ce1c36fb3b76f0dd2e02e959439db49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "481497a4b6508b34f2745f631e6eb7222ce1c36fb3b76f0dd2e02e959439db49"
    sha256 cellar: :any_skip_relocation, ventura:        "b2f9454107553d0ebb67a13b3b3a3c63fd8d53cba12b415865a7dc4dc5684ac7"
    sha256 cellar: :any_skip_relocation, monterey:       "b2f9454107553d0ebb67a13b3b3a3c63fd8d53cba12b415865a7dc4dc5684ac7"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2f9454107553d0ebb67a13b3b3a3c63fd8d53cba12b415865a7dc4dc5684ac7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a2aef853cd6fd8eb593b7c80dcf1218466b77ae5d7928d47891be2643cb969a9"
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
