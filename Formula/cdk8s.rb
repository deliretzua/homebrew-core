require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.113.tgz"
  sha256 "ca72150e6d3a9d32acf4706e733a919124c2a4dd4d9ef1f0f0633be2f953aa4a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4217d9991a21972f7c52c35bb8b6522306ac8f409e4e0e45b40dd8b44cd38a1e"
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
