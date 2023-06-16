class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.38",
      revision: "18aabcffe36cd5717404fb399320db721c486171"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "92db3449da874082312b5c668c3682da29d72de990795775af93663f1bf1e765"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "92db3449da874082312b5c668c3682da29d72de990795775af93663f1bf1e765"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92db3449da874082312b5c668c3682da29d72de990795775af93663f1bf1e765"
    sha256 cellar: :any_skip_relocation, ventura:        "fe9bba3e348c3e9c5c0dc0898e84bd0a5d6d58da7aae99bce11717eebf510d96"
    sha256 cellar: :any_skip_relocation, monterey:       "fe9bba3e348c3e9c5c0dc0898e84bd0a5d6d58da7aae99bce11717eebf510d96"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe9bba3e348c3e9c5c0dc0898e84bd0a5d6d58da7aae99bce11717eebf510d96"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04feee343d22ae51ca10f53f66a491c94fd044a170e6ad41523c19bf738db626"
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
