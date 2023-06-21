require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.315.tgz"
  sha256 "e74e5298967e891d74ccb9d720fe194b7da78697ad164e5b118f51a3331c5174"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ffb4a9e687811d108213147c6553c75180c5aba5862c3b167bbd555f3f3ee50"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ffb4a9e687811d108213147c6553c75180c5aba5862c3b167bbd555f3f3ee50"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ffb4a9e687811d108213147c6553c75180c5aba5862c3b167bbd555f3f3ee50"
    sha256 cellar: :any_skip_relocation, ventura:        "76968d86109d68a6c5b6ef6a789b6cf1929f685725d11fca7a865fb44be428e1"
    sha256 cellar: :any_skip_relocation, monterey:       "76968d86109d68a6c5b6ef6a789b6cf1929f685725d11fca7a865fb44be428e1"
    sha256 cellar: :any_skip_relocation, big_sur:        "76968d86109d68a6c5b6ef6a789b6cf1929f685725d11fca7a865fb44be428e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ffb4a9e687811d108213147c6553c75180c5aba5862c3b167bbd555f3f3ee50"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def wrong_types(a: int, b: int) -> str:
          return a + b
    EOS
    output = pipe_output("#{bin}/pyright broken.py 2>&1")
    assert_match 'error: Expression of type "int" cannot be assigned to return type "str"', output
  end
end
