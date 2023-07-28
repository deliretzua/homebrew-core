class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.48.5.tar.gz"
  sha256 "fcdfc3a7a1e30dcd457f807d2f3064005e7b7eb66012b8df1468539e9a9e3102"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aa0d39468fbf5f998f41c1c4bf6f90ccd0becaf89d534246462b03587e288c9f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aa0d39468fbf5f998f41c1c4bf6f90ccd0becaf89d534246462b03587e288c9f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aa0d39468fbf5f998f41c1c4bf6f90ccd0becaf89d534246462b03587e288c9f"
    sha256 cellar: :any_skip_relocation, ventura:        "759a873354173d7747b572ec8595784973c7204df91bf6862921bf7a48361d2b"
    sha256 cellar: :any_skip_relocation, monterey:       "759a873354173d7747b572ec8595784973c7204df91bf6862921bf7a48361d2b"
    sha256 cellar: :any_skip_relocation, big_sur:        "759a873354173d7747b572ec8595784973c7204df91bf6862921bf7a48361d2b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a56de7135e4899f88029c1b25f5797313f0159edfd61358109bec5bd1cc107a3"
  end

  depends_on "go" => :build

  conflicts_with "tgenv", because: "tgenv symlinks terragrunt binaries"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/terragrunt --version")
  end
end
