require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.50.tgz"
  sha256 "92685e2087f571c3fbb6b7b662b09acfec3ba701cf76acfee7a5dcd06cba8060"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8417825c83d397ebdb02fd230a7799faff78ed42b2632df090f3fd9d84c20be8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8417825c83d397ebdb02fd230a7799faff78ed42b2632df090f3fd9d84c20be8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8417825c83d397ebdb02fd230a7799faff78ed42b2632df090f3fd9d84c20be8"
    sha256 cellar: :any_skip_relocation, ventura:        "db6865563d27083e061eb5593918428b7501cb360581fc9f8ab17a4ead15102f"
    sha256 cellar: :any_skip_relocation, monterey:       "db6865563d27083e061eb5593918428b7501cb360581fc9f8ab17a4ead15102f"
    sha256 cellar: :any_skip_relocation, big_sur:        "db6865563d27083e061eb5593918428b7501cb360581fc9f8ab17a4ead15102f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8417825c83d397ebdb02fd230a7799faff78ed42b2632df090f3fd9d84c20be8"
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
