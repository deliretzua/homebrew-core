class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.529",
      revision: "b1fa0cce1533903801de2696827709274865cdf1"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1fc73c890ed24dd26b178a407e99b2b72569656f19ac1a35a43a8ba1dcc07dc8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1fc73c890ed24dd26b178a407e99b2b72569656f19ac1a35a43a8ba1dcc07dc8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fc73c890ed24dd26b178a407e99b2b72569656f19ac1a35a43a8ba1dcc07dc8"
    sha256 cellar: :any_skip_relocation, ventura:        "b4154767629105cb58abcbf9fa7c08619bddefaf24e924c151c9cfe589eb0339"
    sha256 cellar: :any_skip_relocation, monterey:       "b4154767629105cb58abcbf9fa7c08619bddefaf24e924c151c9cfe589eb0339"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4154767629105cb58abcbf9fa7c08619bddefaf24e924c151c9cfe589eb0339"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0367430eeec850c7816c3973ddb8edd959aa6c80fe0243e6f724b5dd1c361942"
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
