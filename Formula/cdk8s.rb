require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.52.tgz"
  sha256 "35351271b688dc7543900201ef2e51ebbeb9a9a0ad94d49067ef79b33374a8e7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d67d3464bbb7db36485aaf6385e01461bb0b58aa1ee65743c19465b152574c2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d67d3464bbb7db36485aaf6385e01461bb0b58aa1ee65743c19465b152574c2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d67d3464bbb7db36485aaf6385e01461bb0b58aa1ee65743c19465b152574c2"
    sha256 cellar: :any_skip_relocation, ventura:        "cc2ee9edc8eaa664448c371e2c7ec20007017d1e4d7011be7f461df15a0c1618"
    sha256 cellar: :any_skip_relocation, monterey:       "cc2ee9edc8eaa664448c371e2c7ec20007017d1e4d7011be7f461df15a0c1618"
    sha256 cellar: :any_skip_relocation, big_sur:        "cc2ee9edc8eaa664448c371e2c7ec20007017d1e4d7011be7f461df15a0c1618"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d67d3464bbb7db36485aaf6385e01461bb0b58aa1ee65743c19465b152574c2"
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
