class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.46.2.tar.gz"
  sha256 "0d8bb4e98276e68c76d770e662bb434fb5c89f8fc06c3c00e14e717417123ec5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95b739032fa1c80c7a02b78b38e1d13effc0f6ef5009854c0225fcf10e58dd9c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95b739032fa1c80c7a02b78b38e1d13effc0f6ef5009854c0225fcf10e58dd9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95b739032fa1c80c7a02b78b38e1d13effc0f6ef5009854c0225fcf10e58dd9c"
    sha256 cellar: :any_skip_relocation, ventura:        "068af7780ff85083685f19aa9e900a674984e8df58132304c8e43a13fbecfc7d"
    sha256 cellar: :any_skip_relocation, monterey:       "068af7780ff85083685f19aa9e900a674984e8df58132304c8e43a13fbecfc7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "068af7780ff85083685f19aa9e900a674984e8df58132304c8e43a13fbecfc7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92bd0bdd7df7988e983d89ca76795d03ba4aad4d4259bc3da5612ecddc801eb7"
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
