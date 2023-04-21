class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.534",
      revision: "20b9aa6f6dde61c0e529c767873948542fbeadeb"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "039e152d372aedaeada8a680751e5cbbec3edb5a7b9ddf18044b845e52327611"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "039e152d372aedaeada8a680751e5cbbec3edb5a7b9ddf18044b845e52327611"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "039e152d372aedaeada8a680751e5cbbec3edb5a7b9ddf18044b845e52327611"
    sha256 cellar: :any_skip_relocation, ventura:        "9afb664dca6cbabcc8a7afa87982f8a7ddde8414d78ab81aa26352ee031daaf7"
    sha256 cellar: :any_skip_relocation, monterey:       "9afb664dca6cbabcc8a7afa87982f8a7ddde8414d78ab81aa26352ee031daaf7"
    sha256 cellar: :any_skip_relocation, big_sur:        "9afb664dca6cbabcc8a7afa87982f8a7ddde8414d78ab81aa26352ee031daaf7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "091974cbc4963ab40a31304624c11fac5a8ebd83ba1b98f46cd70d7f4272a422"
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
