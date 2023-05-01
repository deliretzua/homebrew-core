class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.45.8.tar.gz"
  sha256 "33780e41a0649f2ec3504cb6e365f191334feb5b90f55ce04193bcd18b570ffe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "492e042503c4533c4be3116fae0f1ebe078d907ece084c61735d02440fef8f9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "492e042503c4533c4be3116fae0f1ebe078d907ece084c61735d02440fef8f9e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "492e042503c4533c4be3116fae0f1ebe078d907ece084c61735d02440fef8f9e"
    sha256 cellar: :any_skip_relocation, ventura:        "2d19f63ca7b5785cb6051fb320f6249e97af8df233abbe06ce12e34441236ffa"
    sha256 cellar: :any_skip_relocation, monterey:       "2d19f63ca7b5785cb6051fb320f6249e97af8df233abbe06ce12e34441236ffa"
    sha256 cellar: :any_skip_relocation, big_sur:        "2d19f63ca7b5785cb6051fb320f6249e97af8df233abbe06ce12e34441236ffa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e8e127c0662cba1589d38220ad515b98c0e17eaf89c850b95a0887aae5832dc"
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
