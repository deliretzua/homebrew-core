require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.16.tgz"
  sha256 "d6cdd5efee655b835f53b190a4c11bc329fc3a5efe769ff85a8eab98ce4f62e8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9708bbb329fff2fdffdf4d352e5d182256689af15498d9f791ec2b288c27c1cc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9708bbb329fff2fdffdf4d352e5d182256689af15498d9f791ec2b288c27c1cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9708bbb329fff2fdffdf4d352e5d182256689af15498d9f791ec2b288c27c1cc"
    sha256 cellar: :any_skip_relocation, ventura:        "0016ab8c15c11ed374ec2e25886ac537f525586d7f2def595e23440d75cf56a2"
    sha256 cellar: :any_skip_relocation, monterey:       "0016ab8c15c11ed374ec2e25886ac537f525586d7f2def595e23440d75cf56a2"
    sha256 cellar: :any_skip_relocation, big_sur:        "0016ab8c15c11ed374ec2e25886ac537f525586d7f2def595e23440d75cf56a2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9708bbb329fff2fdffdf4d352e5d182256689af15498d9f791ec2b288c27c1cc"
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
