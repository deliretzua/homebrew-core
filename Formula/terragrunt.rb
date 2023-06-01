class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.46.0.tar.gz"
  sha256 "46c2e8818848b960783d992c85e112eff994896d6270e259014218dbf227e849"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6e2c3bccc7f1f5cb6e3ea3d44c9165559fc1f9d05149e088e0ff453bae50e864"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e2c3bccc7f1f5cb6e3ea3d44c9165559fc1f9d05149e088e0ff453bae50e864"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e2c3bccc7f1f5cb6e3ea3d44c9165559fc1f9d05149e088e0ff453bae50e864"
    sha256 cellar: :any_skip_relocation, ventura:        "4a64fd4bfba03f2564feb9c4f861068e1aea3a954d3d7b15532cf2693466ece4"
    sha256 cellar: :any_skip_relocation, monterey:       "4a64fd4bfba03f2564feb9c4f861068e1aea3a954d3d7b15532cf2693466ece4"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a64fd4bfba03f2564feb9c4f861068e1aea3a954d3d7b15532cf2693466ece4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9da72afa53f2f01a9f9d5a3503810a105558d61d33da47ab30936c1f48863b5"
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
