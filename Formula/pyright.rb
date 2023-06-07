require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.312.tgz"
  sha256 "37561df721723a157f4364b4f87ee2a90961d681fa8e863671fab928f6f5c42c"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4395026909781c5a775f5b140b81b4443cb7493b3f215d51c375932ffa62452a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4395026909781c5a775f5b140b81b4443cb7493b3f215d51c375932ffa62452a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4395026909781c5a775f5b140b81b4443cb7493b3f215d51c375932ffa62452a"
    sha256 cellar: :any_skip_relocation, ventura:        "ba8c389fd8e6cbe49efb9ccff303537333be57c82fb43339b1afc9ae39795a8e"
    sha256 cellar: :any_skip_relocation, monterey:       "ba8c389fd8e6cbe49efb9ccff303537333be57c82fb43339b1afc9ae39795a8e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba8c389fd8e6cbe49efb9ccff303537333be57c82fb43339b1afc9ae39795a8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4395026909781c5a775f5b140b81b4443cb7493b3f215d51c375932ffa62452a"
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
