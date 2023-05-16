require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.34.tgz"
  sha256 "bc470750a47102d85588cc0203b8f7390d595cb4c617553fb17bd50ff1bb5749"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a02b82699c325c9ad4afa1abcd40db3530f6114b3ed1f5b2e04f67c45ccc7a3e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a02b82699c325c9ad4afa1abcd40db3530f6114b3ed1f5b2e04f67c45ccc7a3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a02b82699c325c9ad4afa1abcd40db3530f6114b3ed1f5b2e04f67c45ccc7a3e"
    sha256 cellar: :any_skip_relocation, ventura:        "e5ae0f5cddcbd970821f96962676281e9d65512e9c2b0cd2cebdf2d218252f7e"
    sha256 cellar: :any_skip_relocation, monterey:       "e5ae0f5cddcbd970821f96962676281e9d65512e9c2b0cd2cebdf2d218252f7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e5ae0f5cddcbd970821f96962676281e9d65512e9c2b0cd2cebdf2d218252f7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a02b82699c325c9ad4afa1abcd40db3530f6114b3ed1f5b2e04f67c45ccc7a3e"
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
