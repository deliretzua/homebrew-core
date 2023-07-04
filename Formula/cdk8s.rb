require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.90.tgz"
  sha256 "39b403ce4037f44ff21083a56879a6f8767fd54aa3e33a4856f1e66606f4bb1f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9aec080bbdc17c146b9aaf0cf3ab5cb75bd073a8539420cf78330e4bd45696f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f9aec080bbdc17c146b9aaf0cf3ab5cb75bd073a8539420cf78330e4bd45696f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9aec080bbdc17c146b9aaf0cf3ab5cb75bd073a8539420cf78330e4bd45696f"
    sha256 cellar: :any_skip_relocation, ventura:        "296033c859b4ea8bdac5e004a6bb1e3e846fe2ab1e7f5375143ad0c992f2b72a"
    sha256 cellar: :any_skip_relocation, monterey:       "296033c859b4ea8bdac5e004a6bb1e3e846fe2ab1e7f5375143ad0c992f2b72a"
    sha256 cellar: :any_skip_relocation, big_sur:        "296033c859b4ea8bdac5e004a6bb1e3e846fe2ab1e7f5375143ad0c992f2b72a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9aec080bbdc17c146b9aaf0cf3ab5cb75bd073a8539420cf78330e4bd45696f"
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
