require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.0.28.tgz"
  sha256 "d5952f25911b988ca9031ec8b220258d38e35155f3e867161b0ba68de5cf29c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "75a1b48f6e501cb9fa766051f6c3c3a0d23e0e1c2676244459b91bf67cdba4da"
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
