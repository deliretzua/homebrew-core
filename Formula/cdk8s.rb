require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.71.tgz"
  sha256 "729cffc05326b65158715f6a66a7c95e3018a53fbb6e31f63000188265e6a532"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "158e927a651fda2d4aebb786d48939a253c3109ac1de9037d1e7658d33cd600c"
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
