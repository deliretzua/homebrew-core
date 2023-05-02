require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.25.tgz"
  sha256 "d7b66f6397373522a19f02d9457a900eb1e1c9e53f6f1c27a30df629dc4a4889"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68cb0131a140e7be03c304dbd169d16afed5fcb4021af58540fec5a7755ff57f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "68cb0131a140e7be03c304dbd169d16afed5fcb4021af58540fec5a7755ff57f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "68cb0131a140e7be03c304dbd169d16afed5fcb4021af58540fec5a7755ff57f"
    sha256 cellar: :any_skip_relocation, ventura:        "4a33968db7d42b3045fd505639aa1adbba9547eab0f809f18299cccba70b2a6f"
    sha256 cellar: :any_skip_relocation, monterey:       "4a33968db7d42b3045fd505639aa1adbba9547eab0f809f18299cccba70b2a6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a33968db7d42b3045fd505639aa1adbba9547eab0f809f18299cccba70b2a6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68cb0131a140e7be03c304dbd169d16afed5fcb4021af58540fec5a7755ff57f"
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
