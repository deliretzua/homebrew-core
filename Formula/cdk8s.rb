require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.70.tgz"
  sha256 "f6fe0b79edd7985175e991c92e1126aa923b524c88e479e3b2db76588e9a5b9b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7e77f9312b54662b7fccc7e62678e678abfbae623cc9be098c8fd81c93e88dc6"
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
