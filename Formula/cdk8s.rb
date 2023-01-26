require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.117.tgz"
  sha256 "5fbef31aa087996e42a1b59a1afaa3f93a217542c5cf8f360bfd4fe330996a50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4bb87c1f8c6fb77849ff2de66747d2eeb5c3ae0b8e8c53e5e3b26f62cd7b7c88"
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
