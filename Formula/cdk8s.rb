require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.14.tgz"
  sha256 "9e51c3860f77780d76a0e3d9faad1c051cc7e14e002c12dc6107e45b0be3a2cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "acf1f82bd1e7a4e7294a930310875b7ffd1e8115a394348fbd990afe8df92c5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "acf1f82bd1e7a4e7294a930310875b7ffd1e8115a394348fbd990afe8df92c5a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "acf1f82bd1e7a4e7294a930310875b7ffd1e8115a394348fbd990afe8df92c5a"
    sha256 cellar: :any_skip_relocation, ventura:        "dab9ac45687b65d97498f75a4c24e8c1f6e4e2afac8bfab5a8cfc0295c0d6b1e"
    sha256 cellar: :any_skip_relocation, monterey:       "dab9ac45687b65d97498f75a4c24e8c1f6e4e2afac8bfab5a8cfc0295c0d6b1e"
    sha256 cellar: :any_skip_relocation, big_sur:        "dab9ac45687b65d97498f75a4c24e8c1f6e4e2afac8bfab5a8cfc0295c0d6b1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "acf1f82bd1e7a4e7294a930310875b7ffd1e8115a394348fbd990afe8df92c5a"
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
