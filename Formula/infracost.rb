class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.9.12.tar.gz"
  sha256 "b61c47d418eb341ab9cda70c48bd45afaf8b920070501f5cb909e27b9d36c8bb"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fa4f870b1e09495e7adcd9c639bea55e8aeeb0da7c2365a8dc0ca9fa4b81e2f9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fa4f870b1e09495e7adcd9c639bea55e8aeeb0da7c2365a8dc0ca9fa4b81e2f9"
    sha256 cellar: :any_skip_relocation, monterey:       "d8bad92116b4a7ffb60b1884d9d37b3c55afdbe97bc53b0dc1fe94591c8dbc3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8bad92116b4a7ffb60b1884d9d37b3c55afdbe97bc53b0dc1fe94591c8dbc3f"
    sha256 cellar: :any_skip_relocation, catalina:       "d8bad92116b4a7ffb60b1884d9d37b3c55afdbe97bc53b0dc1fe94591c8dbc3f"
    sha256 cellar: :any_skip_relocation, mojave:         "d8bad92116b4a7ffb60b1884d9d37b3c55afdbe97bc53b0dc1fe94591c8dbc3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "170fad23d165922751b0132b9f00d396b8010b191bec8448343f2935ce07f9b1"
  end

  depends_on "go" => :build
  depends_on "terraform" => :test

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = "-X github.com/infracost/infracost/internal/version.Version=v#{version}"
    system "go", "build", *std_go_args, "-ldflags", ldflags, "./cmd/infracost"
  end

  test do
    assert_match "v#{version}", shell_output("#{bin}/infracost --version 2>&1")

    output = shell_output("#{bin}/infracost breakdown --no-color 2>&1", 1)
    assert_match "No INFRACOST_API_KEY environment variable is set.", output
  end
end
