require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.50.tgz"
  sha256 "f0e398da7c506cdac15ae8a9b3867ed51c00abf6e2125a307a686e8c1f6e7af7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "d5900b1c14be694123d2266c21dfe304c1fa34e594aa28e15ac40cd856a62b39"
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
