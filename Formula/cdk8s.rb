require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.40.tgz"
  sha256 "fc88fba438f37637304d9aa342b161965c108c3448550bc0ddf449a6f1b35d17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb53f0fc0f8db90fadb71b319b4dd63f2a8a9874029b64af9a682dfc0d6601f0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb53f0fc0f8db90fadb71b319b4dd63f2a8a9874029b64af9a682dfc0d6601f0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb53f0fc0f8db90fadb71b319b4dd63f2a8a9874029b64af9a682dfc0d6601f0"
    sha256 cellar: :any_skip_relocation, ventura:        "6bfb2469338c488e274e49c0cc7f5e6747f648e60932829eda2d45476f028254"
    sha256 cellar: :any_skip_relocation, monterey:       "6bfb2469338c488e274e49c0cc7f5e6747f648e60932829eda2d45476f028254"
    sha256 cellar: :any_skip_relocation, big_sur:        "6bfb2469338c488e274e49c0cc7f5e6747f648e60932829eda2d45476f028254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb53f0fc0f8db90fadb71b319b4dd63f2a8a9874029b64af9a682dfc0d6601f0"
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
