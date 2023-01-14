require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.105.tgz"
  sha256 "683bda5a0e35a926cbe7c359215c7122f45f552d5e2d41e860d5963a1c0b9d23"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d6f80efa5b4bf4b5ca0c46e955a0d777261fd646640e49a368c5304aa3a89d2"
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
