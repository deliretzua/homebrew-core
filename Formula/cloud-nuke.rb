class CloudNuke < Formula
  desc "CLI tool to nuke (delete) cloud resources"
  homepage "https://gruntwork.io/"
  url "https://github.com/gruntwork-io/cloud-nuke/archive/v0.29.6.tar.gz"
  sha256 "633a936856d11e10e1ee0b6145a15e18ceaf56aa1da8bcdba9fb3cb338fffff8"
  license "MIT"
  head "https://github.com/gruntwork-io/cloud-nuke.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d9654f8339e5133c128a10029434ceab6876953cebc2fbd2d8f5fa211314250"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7f2ee02f34abb17e3c901a317bfbb412c8a030a1e3f2b168ada8e8b53e1618bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7fd89613888d9701ea3ba43ed453256d9e111c6989e19cb2b63e063d34bc1df"
    sha256 cellar: :any_skip_relocation, ventura:        "7d85daca818a9e4cfac22d9864bd9cb55bea72cde05f96eba6c5afab3a289f6d"
    sha256 cellar: :any_skip_relocation, monterey:       "8de8035776764d3bb7e7023ed4fc0ff80dac1ce543cecdf49820ffc1333714f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "925d2c16bff62a20a6262a63179e52e31f9b6f6a43da718c8c4f5bb71cc137f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb6157916fe35550b253f2286f26bc54aac3d7338a325a57ec65e03ffcd51c58"
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
