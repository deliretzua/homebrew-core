class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.541",
      revision: "7b4798af43e01a354916bc4cee63e0842851d68a"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "894620d0ee18022353324ee0f7a7d49bf4db6c2290d40544276260d79df5d0cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "894620d0ee18022353324ee0f7a7d49bf4db6c2290d40544276260d79df5d0cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "894620d0ee18022353324ee0f7a7d49bf4db6c2290d40544276260d79df5d0cb"
    sha256 cellar: :any_skip_relocation, ventura:        "39935f19c9c3585d3c6099ff6d8643f2f2d61d80f0c0ca778da3aff0a3557843"
    sha256 cellar: :any_skip_relocation, monterey:       "39935f19c9c3585d3c6099ff6d8643f2f2d61d80f0c0ca778da3aff0a3557843"
    sha256 cellar: :any_skip_relocation, big_sur:        "39935f19c9c3585d3c6099ff6d8643f2f2d61d80f0c0ca778da3aff0a3557843"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f550e4f8dd0132b4ba8b483a43242b2dfa5af7fcc64111c2522e3d21c936fec"
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
