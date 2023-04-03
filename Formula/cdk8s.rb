require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.10.tgz"
  sha256 "534022a35c09810afc2cd00660889ac81dac1588761e8d0628c0e37acf8201a8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bf56a4e740d1b1350d02b0cf27ee9bb14559b2e1739ff7b0ad5baea4e640b04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3bf56a4e740d1b1350d02b0cf27ee9bb14559b2e1739ff7b0ad5baea4e640b04"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3bf56a4e740d1b1350d02b0cf27ee9bb14559b2e1739ff7b0ad5baea4e640b04"
    sha256 cellar: :any_skip_relocation, ventura:        "f07b4be5b651ed48ba5b57c8cae531b2fec8083a7207cbfdfb26d07637e7fc58"
    sha256 cellar: :any_skip_relocation, monterey:       "f07b4be5b651ed48ba5b57c8cae531b2fec8083a7207cbfdfb26d07637e7fc58"
    sha256 cellar: :any_skip_relocation, big_sur:        "f07b4be5b651ed48ba5b57c8cae531b2fec8083a7207cbfdfb26d07637e7fc58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3bf56a4e740d1b1350d02b0cf27ee9bb14559b2e1739ff7b0ad5baea4e640b04"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
