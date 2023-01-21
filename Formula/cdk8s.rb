require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.112.tgz"
  sha256 "ff0909c98df2d957f9f5ea3c22f264bb9973171f036dec8ddbab1003e3660868"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "bbead078d37a3015aa92b220424bbd827c286fa0e8faf2243f8b8b4d071e81ad"
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
