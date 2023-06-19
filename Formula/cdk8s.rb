require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.66.tgz"
  sha256 "528b8da94ad0ff4c1a4c9e2956597018cdae60e1ebae3e31cafd5429e20b392a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bb96a26cf555d361a370d431ba7f60a47b4e6deeeb587490d4d35acab60e7dd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1bb96a26cf555d361a370d431ba7f60a47b4e6deeeb587490d4d35acab60e7dd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1bb96a26cf555d361a370d431ba7f60a47b4e6deeeb587490d4d35acab60e7dd"
    sha256 cellar: :any_skip_relocation, ventura:        "b366f09accb70d96de081fb2034dbac990ccdd312e2a01251ac0629fd0b35869"
    sha256 cellar: :any_skip_relocation, monterey:       "b366f09accb70d96de081fb2034dbac990ccdd312e2a01251ac0629fd0b35869"
    sha256 cellar: :any_skip_relocation, big_sur:        "b366f09accb70d96de081fb2034dbac990ccdd312e2a01251ac0629fd0b35869"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bb96a26cf555d361a370d431ba7f60a47b4e6deeeb587490d4d35acab60e7dd"
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
