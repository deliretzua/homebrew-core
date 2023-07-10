require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.101.tgz"
  sha256 "778d94a93311404007f9082cf64769c39f6858ef97237e29b4dd524618c1dd76"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7dfaec75f2859d3d2197fc08c8aed72b3a722325441e64179c2c0167341a6636"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7dfaec75f2859d3d2197fc08c8aed72b3a722325441e64179c2c0167341a6636"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7dfaec75f2859d3d2197fc08c8aed72b3a722325441e64179c2c0167341a6636"
    sha256 cellar: :any_skip_relocation, ventura:        "c671cbc8f7d98d8b10d8aa822da3b99fe7a78d663a85576010b91b67af59a54c"
    sha256 cellar: :any_skip_relocation, monterey:       "c671cbc8f7d98d8b10d8aa822da3b99fe7a78d663a85576010b91b67af59a54c"
    sha256 cellar: :any_skip_relocation, big_sur:        "c671cbc8f7d98d8b10d8aa822da3b99fe7a78d663a85576010b91b67af59a54c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7dfaec75f2859d3d2197fc08c8aed72b3a722325441e64179c2c0167341a6636"
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
