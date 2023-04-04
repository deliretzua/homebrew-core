class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.45.1.tar.gz"
  sha256 "c29d446dfce2e1536d059afdc83eec704a478a1dc4756053c084d72ab824ab42"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76bfbbe23d1330d107f02de0ed82f1ff9dc768dfe101bf3d80fedbb527d12ccf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "76bfbbe23d1330d107f02de0ed82f1ff9dc768dfe101bf3d80fedbb527d12ccf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76bfbbe23d1330d107f02de0ed82f1ff9dc768dfe101bf3d80fedbb527d12ccf"
    sha256 cellar: :any_skip_relocation, ventura:        "436b6e5b79ba0de8fcf35ab321ba2198b77aa35c48987c6c47175f122e837edd"
    sha256 cellar: :any_skip_relocation, monterey:       "436b6e5b79ba0de8fcf35ab321ba2198b77aa35c48987c6c47175f122e837edd"
    sha256 cellar: :any_skip_relocation, big_sur:        "436b6e5b79ba0de8fcf35ab321ba2198b77aa35c48987c6c47175f122e837edd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e30ac47aedaffdd5642f8e401aee25718044d2376f64bb23592a55b8558f1b47"
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
