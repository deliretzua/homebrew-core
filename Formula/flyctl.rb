class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.19",
      revision: "4a8984cfdbf45a4bffea06fc16b02440d106456c"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "325d3df6bfd37505b36bc737edb3f235273a9ecf69b50cf02125973fc795398d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "325d3df6bfd37505b36bc737edb3f235273a9ecf69b50cf02125973fc795398d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "325d3df6bfd37505b36bc737edb3f235273a9ecf69b50cf02125973fc795398d"
    sha256 cellar: :any_skip_relocation, ventura:        "dfc41f9117e7d169ecc916ba359276e5b6f981c20d7c338eace14cfb6b44d54b"
    sha256 cellar: :any_skip_relocation, monterey:       "dfc41f9117e7d169ecc916ba359276e5b6f981c20d7c338eace14cfb6b44d54b"
    sha256 cellar: :any_skip_relocation, big_sur:        "dfc41f9117e7d169ecc916ba359276e5b6f981c20d7c338eace14cfb6b44d54b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "34d7eefd754b5c10c37402903dc9267ca734bb3c31a837fb47587c26833863e0"
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
