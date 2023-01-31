require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.122.tgz"
  sha256 "6b4316053b52cfd2e2a428e8c3ce5828a84489954ea74fdfa42d437610455241"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b395c28ca7f176706686198ecd5123a3c562ee9a96251caacf00776db2bf542d"
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
