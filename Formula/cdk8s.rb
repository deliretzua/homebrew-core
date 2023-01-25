require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.116.tgz"
  sha256 "32e56cfd9a798ebecfa1996733297397e7cee7a6cd1c7e4d0c20c3dceae42f9b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "82c2c4780aeb98afd39e125db97344e60c02b9cb0225f0220def01e11f45ba67"
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
