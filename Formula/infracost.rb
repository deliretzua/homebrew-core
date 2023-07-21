class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.26.tar.gz"
  sha256 "229ad9d92d9a90d693bd3adf1bd2d2e931ef703c1bff54b9c7acf491c79ef451"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8598be3eb75f3c2bc2248072965137942104ccb28092dab483321a292c60158c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8598be3eb75f3c2bc2248072965137942104ccb28092dab483321a292c60158c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8598be3eb75f3c2bc2248072965137942104ccb28092dab483321a292c60158c"
    sha256 cellar: :any_skip_relocation, ventura:        "c17f11883fd0a3842e1bb4b7d96fe150ecb1432eb0edd5feab0b71ba7e38477f"
    sha256 cellar: :any_skip_relocation, monterey:       "c17f11883fd0a3842e1bb4b7d96fe150ecb1432eb0edd5feab0b71ba7e38477f"
    sha256 cellar: :any_skip_relocation, big_sur:        "c17f11883fd0a3842e1bb4b7d96fe150ecb1432eb0edd5feab0b71ba7e38477f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a43322334897ac775a27feee1a5a5022c02789d482edc102395d5616b56a08b2"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/infracost"

    generate_completions_from_executable(bin/"infracost", "completion", "--shell")
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
