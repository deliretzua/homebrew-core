require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.5.tgz"
  sha256 "e7888030705eed1986ae9b270e591b371112e972b3fc0b379034a7b4d7245a18"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "a8cbb7c9b6facbc96856324125190b4cf95f30cd4f843c2b9660bf86e2475f33"
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
