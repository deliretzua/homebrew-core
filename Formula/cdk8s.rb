require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.64.tgz"
  sha256 "459bc9d2936bb5778d3f4927a7f0bf1572e22e7afc2dfe17f07305baf05932c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1bb6dee04fa6feefe488944e4c764d0364af29774c9c880608b5803a92b40959"
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
