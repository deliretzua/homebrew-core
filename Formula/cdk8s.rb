require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.34.tgz"
  sha256 "ca663747c0a62a501c12d8f348f130a9b533e91c6b9e6e584209d8580c39ca39"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "623d9b562e3bfa43ab2f39137b751d95ffef4a0c78e03013d2231e661121a819"
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
