require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.106.tgz"
  sha256 "244184227a397f5d4b162f39ec46bb2f62e686e15310d52801a0e07731f4f5bf"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "79207a3b2f62236d164f2b9422fcd24eddbad6e3a9435f10c4a6f5eca3b869d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "79207a3b2f62236d164f2b9422fcd24eddbad6e3a9435f10c4a6f5eca3b869d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "79207a3b2f62236d164f2b9422fcd24eddbad6e3a9435f10c4a6f5eca3b869d9"
    sha256 cellar: :any_skip_relocation, ventura:        "639df7f380f8774525e39f32295f3f1e1bbc0b7c93db8f006a743f855495acff"
    sha256 cellar: :any_skip_relocation, monterey:       "639df7f380f8774525e39f32295f3f1e1bbc0b7c93db8f006a743f855495acff"
    sha256 cellar: :any_skip_relocation, big_sur:        "639df7f380f8774525e39f32295f3f1e1bbc0b7c93db8f006a743f855495acff"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79207a3b2f62236d164f2b9422fcd24eddbad6e3a9435f10c4a6f5eca3b869d9"
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
