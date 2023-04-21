class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.532",
      revision: "c10507f048be9f54a8eb872b3b67bd2cf1acdc3f"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e17a94e34151710c0a8a373f2a24cb3b55a174364f84055270a4449a98c502d3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e17a94e34151710c0a8a373f2a24cb3b55a174364f84055270a4449a98c502d3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e17a94e34151710c0a8a373f2a24cb3b55a174364f84055270a4449a98c502d3"
    sha256 cellar: :any_skip_relocation, ventura:        "d0d0a69792932eb0f1368b70fa5e90e3527e7dc95b7e997bfdba68c126d67f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "d0d0a69792932eb0f1368b70fa5e90e3527e7dc95b7e997bfdba68c126d67f6d"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0d0a69792932eb0f1368b70fa5e90e3527e7dc95b7e997bfdba68c126d67f6d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e454037640475b60d2f02c285e5a7efebc9466cd4a2e53b53a31972647801358"
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
