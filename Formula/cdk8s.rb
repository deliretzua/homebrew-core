require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.118.tgz"
  sha256 "f7339251db96ea28084dc2565b573caa308f23faf5c6034b6d4b548c21540bd8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "95708e07ce844a26a768ce4c75487234b17fc7b276336ac87f968a9dd871c6d6"
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
