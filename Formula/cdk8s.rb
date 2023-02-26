require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.143.tgz"
  sha256 "aa773050eb1aff324c5d1028470e64abf3413706cc71580c7a92ba794ab1b644"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "85e84de82b23dd776889308adbd377ef4e679558cd7dba5da5580fc699cd982d"
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
