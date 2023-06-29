require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.82.tgz"
  sha256 "21d9eeccd1e039b8f58e15d3a7746aae3a3f2942a0983eabec24ecd03d0b0732"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dba872e5200e3da567f81e3d9963707253c380178cc9dbd8a79de262b4a838b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dba872e5200e3da567f81e3d9963707253c380178cc9dbd8a79de262b4a838b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dba872e5200e3da567f81e3d9963707253c380178cc9dbd8a79de262b4a838b3"
    sha256 cellar: :any_skip_relocation, ventura:        "74f7f1d4bf073d4b5ae828b06ccb9f087aee1770f07969873c09421f23ebd2fe"
    sha256 cellar: :any_skip_relocation, monterey:       "74f7f1d4bf073d4b5ae828b06ccb9f087aee1770f07969873c09421f23ebd2fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "74f7f1d4bf073d4b5ae828b06ccb9f087aee1770f07969873c09421f23ebd2fe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dba872e5200e3da567f81e3d9963707253c380178cc9dbd8a79de262b4a838b3"
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
