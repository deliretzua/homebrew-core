require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.11.0.tgz"
  sha256 "12e6f17fdc9f7217532743be453fa1f20727e11214fd330534f34eea414b1801"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a65c4dadf524109b339517affcc4a7924bc512e114f16959989756874726e2b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a65c4dadf524109b339517affcc4a7924bc512e114f16959989756874726e2b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a65c4dadf524109b339517affcc4a7924bc512e114f16959989756874726e2b0"
    sha256 cellar: :any_skip_relocation, ventura:        "a689edd5890db6be8e2e83b0859644e40768a4a42f56069fa9e4e0a07b70373e"
    sha256 cellar: :any_skip_relocation, monterey:       "a689edd5890db6be8e2e83b0859644e40768a4a42f56069fa9e4e0a07b70373e"
    sha256 cellar: :any_skip_relocation, big_sur:        "a689edd5890db6be8e2e83b0859644e40768a4a42f56069fa9e4e0a07b70373e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eb529516880aa9eb9e97a0eb09f3fbc3a23c5f4d21a074c841c4f11512be3f44"
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
