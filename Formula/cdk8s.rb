require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.44.tgz"
  sha256 "d12263dd0c38032f698d736c7cd3ba86432c740dfed0357a80f756841623f55b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "aebfbfb8b6fd0626c7ed5485ff9dbf927db04f702b37b29191eb41fe15e7bf32"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "aebfbfb8b6fd0626c7ed5485ff9dbf927db04f702b37b29191eb41fe15e7bf32"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "aebfbfb8b6fd0626c7ed5485ff9dbf927db04f702b37b29191eb41fe15e7bf32"
    sha256 cellar: :any_skip_relocation, ventura:        "393aa604e3988ca08ae4cabdc8f97b9ba952551b341c701a4c468a6aad30ddc7"
    sha256 cellar: :any_skip_relocation, monterey:       "393aa604e3988ca08ae4cabdc8f97b9ba952551b341c701a4c468a6aad30ddc7"
    sha256 cellar: :any_skip_relocation, big_sur:        "393aa604e3988ca08ae4cabdc8f97b9ba952551b341c701a4c468a6aad30ddc7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aebfbfb8b6fd0626c7ed5485ff9dbf927db04f702b37b29191eb41fe15e7bf32"
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
