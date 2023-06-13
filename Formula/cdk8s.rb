require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.58.tgz"
  sha256 "4e78c3f4f5f56d0d89682b176dd427343676e0e9420f451d52aa46461188b6ac"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e3def4afa6b44a28a4ce90eb38cbf0b44d2927fc7b57aeecc3a73757a779309e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3def4afa6b44a28a4ce90eb38cbf0b44d2927fc7b57aeecc3a73757a779309e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e3def4afa6b44a28a4ce90eb38cbf0b44d2927fc7b57aeecc3a73757a779309e"
    sha256 cellar: :any_skip_relocation, ventura:        "8a8dbd9129062c66cab6cf2f6fc217d9a71c3163aa38574a5ddc45a805696840"
    sha256 cellar: :any_skip_relocation, monterey:       "8a8dbd9129062c66cab6cf2f6fc217d9a71c3163aa38574a5ddc45a805696840"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a8dbd9129062c66cab6cf2f6fc217d9a71c3163aa38574a5ddc45a805696840"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3def4afa6b44a28a4ce90eb38cbf0b44d2927fc7b57aeecc3a73757a779309e"
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
