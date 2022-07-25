require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.62.tgz"
  sha256 "770470e52af1598e6c0b2699bfaa36fc810241c4ebb0bc4059d6faa046253e93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6501b72e6ebd30f3c372f2629d8ccd69f59554760ba9c3ca932fa3e16712bbe4"
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
