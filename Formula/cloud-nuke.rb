class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.31.2.tar.gz"
  sha256 "dc0d3737dbf0ad06c5ab2be0585797f6a577b3d4e701d859466f146af1361b8b"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5c547e3720fde27ecc8fda6097f2b33787db6b86523b40d653847a539e9c08c3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5c547e3720fde27ecc8fda6097f2b33787db6b86523b40d653847a539e9c08c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5c547e3720fde27ecc8fda6097f2b33787db6b86523b40d653847a539e9c08c3"
    sha256 cellar: :any_skip_relocation, ventura:        "409a0bee4bf439233c8dff35ff9c82ae568eb60bbdcb9c364fd5b6bf9014c654"
    sha256 cellar: :any_skip_relocation, monterey:       "409a0bee4bf439233c8dff35ff9c82ae568eb60bbdcb9c364fd5b6bf9014c654"
    sha256 cellar: :any_skip_relocation, big_sur:        "409a0bee4bf439233c8dff35ff9c82ae568eb60bbdcb9c364fd5b6bf9014c654"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c113f1f12dfa8b903e4fb31beb32b4557ac0969fee70fc311ea00f45fe66a0fa"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X main.VERSION=v#{version}")
  end

  test do
    assert_match "A CLI tool to nuke (delete) cloud resources", shell_output("#{bin}/cloud-nuke --help 2>1&")
    assert_match "ec2", shell_output("#{bin}/cloud-nuke aws --list-resource-types")
  end
end
