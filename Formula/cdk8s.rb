require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.72.tgz"
  sha256 "cf6f5f02d69ff53d0e48710392112f9e3567ccc53f5cd536a55952e67cc58a82"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2c852e071389afd26aa41977ed5e41275ccb4b5d5afcdfffac1d8f7686295bb8"
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
