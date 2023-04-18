require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.13.tgz"
  sha256 "5e1a986455acd36dd7728377f066e6fa4ac4a1b4d1faee5d7d1244b0a4944d71"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b1f3c6a52089136c78c40874ede96a4fa11c2636069117697297cbb2aa497125"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1f3c6a52089136c78c40874ede96a4fa11c2636069117697297cbb2aa497125"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1f3c6a52089136c78c40874ede96a4fa11c2636069117697297cbb2aa497125"
    sha256 cellar: :any_skip_relocation, ventura:        "2afe1ccdaab3862f423a92e5d9147009f0d9cd3ada0db1bc447d4c32256fd7ae"
    sha256 cellar: :any_skip_relocation, monterey:       "2afe1ccdaab3862f423a92e5d9147009f0d9cd3ada0db1bc447d4c32256fd7ae"
    sha256 cellar: :any_skip_relocation, big_sur:        "2afe1ccdaab3862f423a92e5d9147009f0d9cd3ada0db1bc447d4c32256fd7ae"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b1f3c6a52089136c78c40874ede96a4fa11c2636069117697297cbb2aa497125"
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
