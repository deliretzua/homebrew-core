require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.114.tgz"
  sha256 "3674a9853bbd2ae04eb9a359503000aa7f216c1cf4a41c056110740d3a628ce1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "06e7a233f825cdf04f7ee3f2f0c6947676283162207d065eea726bccacadc861"
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
