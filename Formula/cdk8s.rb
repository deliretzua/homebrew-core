require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.87.tgz"
  sha256 "f994d763016c8799a8c4c7512c5e7c08023e0256fd4e4fd661addb7dca6d2ed6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "e3fa5d8f8eb6d9baceafaf3b5c9912cb4fc014b5943529ce40328688beae5088"
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
