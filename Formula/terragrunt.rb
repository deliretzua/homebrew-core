class Terragrunt < Formula
  desc "Thin wrapper for Terraform e.g. for locking state"
  homepage "https://terragrunt.gruntwork.io/"
  url "https://github.com/gruntwork-io/terragrunt/archive/v0.45.9.tar.gz"
  sha256 "fa55db244a60667f8cf7a86a8b9d53c7df6ab22f4498e7665ae6bb8d36a4c97d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24ae15336a1ffa53e92068fd26acf2ff607dd2e493480da701ce3733b2edbd9b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "24ae15336a1ffa53e92068fd26acf2ff607dd2e493480da701ce3733b2edbd9b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "24ae15336a1ffa53e92068fd26acf2ff607dd2e493480da701ce3733b2edbd9b"
    sha256 cellar: :any_skip_relocation, ventura:        "560946e10a8b6d832fd886b3195e56bfeeeeb0d1b4dbcb1960e30f2a84c6b87b"
    sha256 cellar: :any_skip_relocation, monterey:       "560946e10a8b6d832fd886b3195e56bfeeeeb0d1b4dbcb1960e30f2a84c6b87b"
    sha256 cellar: :any_skip_relocation, big_sur:        "560946e10a8b6d832fd886b3195e56bfeeeeb0d1b4dbcb1960e30f2a84c6b87b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7403f40f8d4eca7000b808659e1c0e9b0b096ade6b75442845ec723f3cd0061"
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
