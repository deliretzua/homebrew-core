require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.19.tgz"
  sha256 "f040d1e3e16064c1e2ce67fe73a62b3764580e820e4c6447fede9ec8321cd97e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6b891b6528a69fc68a616bbb940515be0c4c6e97249a384e6c0801a929815dcd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b891b6528a69fc68a616bbb940515be0c4c6e97249a384e6c0801a929815dcd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b891b6528a69fc68a616bbb940515be0c4c6e97249a384e6c0801a929815dcd"
    sha256 cellar: :any_skip_relocation, ventura:        "e030cbd0a46566b20bb54820f39465a1598c5e4ed5334a63f89fcb1f6bc6b064"
    sha256 cellar: :any_skip_relocation, monterey:       "e030cbd0a46566b20bb54820f39465a1598c5e4ed5334a63f89fcb1f6bc6b064"
    sha256 cellar: :any_skip_relocation, big_sur:        "e030cbd0a46566b20bb54820f39465a1598c5e4ed5334a63f89fcb1f6bc6b064"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6b891b6528a69fc68a616bbb940515be0c4c6e97249a384e6c0801a929815dcd"
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
