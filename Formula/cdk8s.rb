require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.47.tgz"
  sha256 "0a4c8974179a3f33bc4e21c29233d810fd3a0453ac0b7f71988f591ba07d7e6a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59de4a61d37c36f949680b233dbe2cf6111395cdd602226ef05fecf6c4f169f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59de4a61d37c36f949680b233dbe2cf6111395cdd602226ef05fecf6c4f169f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59de4a61d37c36f949680b233dbe2cf6111395cdd602226ef05fecf6c4f169f5"
    sha256 cellar: :any_skip_relocation, ventura:        "c5184aab1060d3494e34aa866fcd195682b77a8b8e3025757076e197b44cfb5b"
    sha256 cellar: :any_skip_relocation, monterey:       "713a5af1eec669b9559238818a7eccfc542af1ea449d1ffb0216d13fa6a597a3"
    sha256 cellar: :any_skip_relocation, big_sur:        "c5184aab1060d3494e34aa866fcd195682b77a8b8e3025757076e197b44cfb5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59de4a61d37c36f949680b233dbe2cf6111395cdd602226ef05fecf6c4f169f5"
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
