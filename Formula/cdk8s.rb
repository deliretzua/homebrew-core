require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.94.tgz"
  sha256 "33d9c901dcb2bb67b96a702e3c4f0c0e4ec36f5828cde4498b42a4efbbb2f461"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "894855e88262e47520a79d152f1ba98692e1bdb9d62866bae2d3c8e1efa616b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "894855e88262e47520a79d152f1ba98692e1bdb9d62866bae2d3c8e1efa616b5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "894855e88262e47520a79d152f1ba98692e1bdb9d62866bae2d3c8e1efa616b5"
    sha256 cellar: :any_skip_relocation, ventura:        "c882d003a704a9fad3b8095fae3c883c5b0ab636d3c4ebfc0057ff24e189d3d5"
    sha256 cellar: :any_skip_relocation, monterey:       "c882d003a704a9fad3b8095fae3c883c5b0ab636d3c4ebfc0057ff24e189d3d5"
    sha256 cellar: :any_skip_relocation, big_sur:        "c882d003a704a9fad3b8095fae3c883c5b0ab636d3c4ebfc0057ff24e189d3d5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "894855e88262e47520a79d152f1ba98692e1bdb9d62866bae2d3c8e1efa616b5"
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
