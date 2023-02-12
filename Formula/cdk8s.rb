require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.134.tgz"
  sha256 "4825332aa9d4ada8fb0309dfd2d89851421d7ff85dd64efbc90d2ef59fb43733"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6fb1bf3cdbffc0717e765a6af52c8e412d5831ea50b78bdb20e821a202002318"
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
