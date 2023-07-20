class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.63",
      revision: "3996140193a9de435c13d9e21d26e6742f0866c1"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "77c71b7f45f54b7d9bfca48fd35170a0990d43f1b5eb2ccec912e387c4e85d84"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77c71b7f45f54b7d9bfca48fd35170a0990d43f1b5eb2ccec912e387c4e85d84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77c71b7f45f54b7d9bfca48fd35170a0990d43f1b5eb2ccec912e387c4e85d84"
    sha256 cellar: :any_skip_relocation, ventura:        "dfe6cf29cdf6b2fa943e358ae2bee5cdd132510018bb3f2e377acc1e5dc6ada9"
    sha256 cellar: :any_skip_relocation, monterey:       "dfe6cf29cdf6b2fa943e358ae2bee5cdd132510018bb3f2e377acc1e5dc6ada9"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfe6cf29cdf6b2fa943e358ae2bee5cdd132510018bb3f2e377acc1e5dc6ada9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c05d45b88351fe1b7a982708946f5d3ca2258b768ca9a387b0a75c8af23e98b"
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
