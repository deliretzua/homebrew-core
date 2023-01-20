require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.111.tgz"
  sha256 "c0fd50db17242df29830f4d08edb2c02a82a7e3647625633a71fd59b537fb178"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9ddb3e345d68b66420ffaef7664e36acabcd430c9b004ee29a3b40baa1487d03"
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
