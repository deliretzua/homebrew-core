require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.109.tgz"
  sha256 "44166a2bbcfb0f8a07ba321de964a174d6e2fcc748827ace8bce75572f426a04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "6645abd10fa7d76baea97187bc70205840cd96b753666f1ae1fa33efbe51fb3d"
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
