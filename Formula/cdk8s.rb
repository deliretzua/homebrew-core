require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.79.tgz"
  sha256 "07e4b7f64a19fae6112f310f7f6d03f405e60c6727b222ad6e7c48f697d23957"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d74d731da8cd9e07947b0910749ab0b97b5179933a2b1eb2bb0cbf9310c6eebb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d74d731da8cd9e07947b0910749ab0b97b5179933a2b1eb2bb0cbf9310c6eebb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d74d731da8cd9e07947b0910749ab0b97b5179933a2b1eb2bb0cbf9310c6eebb"
    sha256 cellar: :any_skip_relocation, ventura:        "481757e4e2e3478efbed2fc230701f4a0aba1930bf7b15b330f6077228253cbb"
    sha256 cellar: :any_skip_relocation, monterey:       "481757e4e2e3478efbed2fc230701f4a0aba1930bf7b15b330f6077228253cbb"
    sha256 cellar: :any_skip_relocation, big_sur:        "481757e4e2e3478efbed2fc230701f4a0aba1930bf7b15b330f6077228253cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d74d731da8cd9e07947b0910749ab0b97b5179933a2b1eb2bb0cbf9310c6eebb"
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
