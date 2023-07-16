require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.112.tgz"
  sha256 "68f298c62cbf5ad6cfe709e607dffb083d575c0868bf2beff447c6d7129edf37"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9bd0cfe93ec270e60b755549baf4476af0fc05295d1fcc0244862e6a457c5fd8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9bd0cfe93ec270e60b755549baf4476af0fc05295d1fcc0244862e6a457c5fd8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9bd0cfe93ec270e60b755549baf4476af0fc05295d1fcc0244862e6a457c5fd8"
    sha256 cellar: :any_skip_relocation, ventura:        "41105a8eac6f96aec8294e9398349b6dd276db41b4c1c80dbada454e8c67b42a"
    sha256 cellar: :any_skip_relocation, monterey:       "41105a8eac6f96aec8294e9398349b6dd276db41b4c1c80dbada454e8c67b42a"
    sha256 cellar: :any_skip_relocation, big_sur:        "41105a8eac6f96aec8294e9398349b6dd276db41b4c1c80dbada454e8c67b42a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bd0cfe93ec270e60b755549baf4476af0fc05295d1fcc0244862e6a457c5fd8"
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
