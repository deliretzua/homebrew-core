class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.552",
      revision: "159d1b0419dff73e23a83fcf3dae86975aff89d3"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bd9a66ef7ab8661fe6b1bce1449d47a65d3712263ce7561be065149e6146e507"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bd9a66ef7ab8661fe6b1bce1449d47a65d3712263ce7561be065149e6146e507"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bd9a66ef7ab8661fe6b1bce1449d47a65d3712263ce7561be065149e6146e507"
    sha256 cellar: :any_skip_relocation, ventura:        "a5490ddb1d6f53d151a934c007c16e158a115ef7aa33986cc794327ea94d49b9"
    sha256 cellar: :any_skip_relocation, monterey:       "a5490ddb1d6f53d151a934c007c16e158a115ef7aa33986cc794327ea94d49b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "a5490ddb1d6f53d151a934c007c16e158a115ef7aa33986cc794327ea94d49b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "91c5df0d3e30ffa107aca643695a6546aa1b75af21d59fd80d70be3184860857"
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
