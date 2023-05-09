class Infracost < Formula
  desc "Cost estimates for Terraform"
  homepage "https://www.infracost.io/docs/"
  url "https://github.com/infracost/infracost/archive/v0.10.22.tar.gz"
  sha256 "274b3379e37daee40eceb581f72e873a53ff9e5bf881f86b168947d9203853fe"
  license "Apache-2.0"
  head "https://github.com/infracost/infracost.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "63c34084a9066f8ed261d984cd845205a76ce09464fa674fbf7b00e9bb163ba3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "63c34084a9066f8ed261d984cd845205a76ce09464fa674fbf7b00e9bb163ba3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63c34084a9066f8ed261d984cd845205a76ce09464fa674fbf7b00e9bb163ba3"
    sha256 cellar: :any_skip_relocation, ventura:        "fe72e93f6afa000f23571acff5030497118a6e5ffcc41850c5768e4e54f2b5be"
    sha256 cellar: :any_skip_relocation, monterey:       "fe72e93f6afa000f23571acff5030497118a6e5ffcc41850c5768e4e54f2b5be"
    sha256 cellar: :any_skip_relocation, big_sur:        "fe72e93f6afa000f23571acff5030497118a6e5ffcc41850c5768e4e54f2b5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a57c97d43764480256500571738645d60d7784814e2c33f50f5497aba7ad8878"
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
