require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.128.tgz"
  sha256 "7a08c223264a97bbccc97ab67f1125f86cce3e6fd115117dd423b7adc761c0fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2436707f8fc17a774d13cce1cab8c06858a0a71e51c5e32b89ada302d45f2bd9"
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
