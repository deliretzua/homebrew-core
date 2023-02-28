require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.145.tgz"
  sha256 "13d1093ed97f7affaba25d0641b9136da5c171cdfc110a834db97627f5b0aeec"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "262db09d44f6307ef3996672e15511661e1a0a2f7c3548b1bf7f556516ff0036"
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
