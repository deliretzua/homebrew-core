require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.1.142.tgz"
  sha256 "2d12c52f1a3e1b3f7c641f1107ae6df5fca86ce92fe9b687cf56476d9de4ab75"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "08aa8a3eb436b3d809d4c2b4a41f1fd1f0c837e91a8b7f92db2f8553fcaeda7f"
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
