require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-1.0.115.tgz"
  sha256 "3135425da9ee0755fa617f536a737119f0781262f61207020dc811f1a8e29601"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "16fa374f77e601042fc4054e88abe343cff231a20c69782d4e37dddddfede31e"
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
