class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.1.49",
      revision: "015492d931c0161d835007a9c3ebf7b1b7586b25"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e83488a7b6669926591fa472b7818bb89e8e12f5125f9262b54b7fe5c5f4afd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e83488a7b6669926591fa472b7818bb89e8e12f5125f9262b54b7fe5c5f4afd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e83488a7b6669926591fa472b7818bb89e8e12f5125f9262b54b7fe5c5f4afd5"
    sha256 cellar: :any_skip_relocation, ventura:        "2100251cd0aa31fc94ca1a3ab5cb976363017c84544e397639f926ab1efcd66e"
    sha256 cellar: :any_skip_relocation, monterey:       "2100251cd0aa31fc94ca1a3ab5cb976363017c84544e397639f926ab1efcd66e"
    sha256 cellar: :any_skip_relocation, big_sur:        "2100251cd0aa31fc94ca1a3ab5cb976363017c84544e397639f926ab1efcd66e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d6c2c709a8f5bf7b6ce85ba943203c5ae439babcdbaaafdab85e2e795eaee47"
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
