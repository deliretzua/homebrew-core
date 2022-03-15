require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.124.tgz"
  sha256 "4b719c0c0bd99ed6d5cf5a4e61f24c0ea226394fdabbb79da4d4b195f6a20c1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a014a47df55d2f87b9d6892c145f494485060b7356dd9dfc52af7c03cecbe25e"
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
