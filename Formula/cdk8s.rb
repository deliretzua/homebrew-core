require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.103.tgz"
  sha256 "68e7adfdb69714ab5a3beec859963bd608492407538198f1100ea7fc6c8040fb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9fec43d09591faf744c7d2ec1f173023a04b88a823a15e9aaa42d16b9857e235"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9fec43d09591faf744c7d2ec1f173023a04b88a823a15e9aaa42d16b9857e235"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9fec43d09591faf744c7d2ec1f173023a04b88a823a15e9aaa42d16b9857e235"
    sha256 cellar: :any_skip_relocation, ventura:        "520214bae619a0a66f7e4a83321e074587c5035ea3c4e285bf5ad6504678dace"
    sha256 cellar: :any_skip_relocation, monterey:       "520214bae619a0a66f7e4a83321e074587c5035ea3c4e285bf5ad6504678dace"
    sha256 cellar: :any_skip_relocation, big_sur:        "520214bae619a0a66f7e4a83321e074587c5035ea3c4e285bf5ad6504678dace"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fec43d09591faf744c7d2ec1f173023a04b88a823a15e9aaa42d16b9857e235"
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
