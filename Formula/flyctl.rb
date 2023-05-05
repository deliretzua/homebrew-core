class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.558",
      revision: "44f30c4873134c3bae484271344c96204de20c4c"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ff2c48cb244a421587a0738f95b6150c655022e0fc01bdce5b1993f7c77a1a5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ff2c48cb244a421587a0738f95b6150c655022e0fc01bdce5b1993f7c77a1a5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ff2c48cb244a421587a0738f95b6150c655022e0fc01bdce5b1993f7c77a1a5"
    sha256 cellar: :any_skip_relocation, ventura:        "7790de5ee59dc87fe4f30c2222e35d8e90e8ef81b70e71cb8c51103bc7b2f3cb"
    sha256 cellar: :any_skip_relocation, monterey:       "7790de5ee59dc87fe4f30c2222e35d8e90e8ef81b70e71cb8c51103bc7b2f3cb"
    sha256 cellar: :any_skip_relocation, big_sur:        "7790de5ee59dc87fe4f30c2222e35d8e90e8ef81b70e71cb8c51103bc7b2f3cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22bbb6b4d3b381608658850a956901b934ad733569c6f3948b4438ecb103e95e"
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
