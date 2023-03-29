require "language/node"

class Pyright < Formula
  desc "Static type checker for Python"
  homepage "https://github.com/microsoft/pyright"
  url "https://registry.npmjs.org/pyright/-/pyright-1.1.301.tgz"
  sha256 "27c524ae6470b969afdae1f38164b1c11ed84768b809f2f2a4d510077792eeec"
  license "MIT"
  head "https://github.com/microsoft/pyright.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c9b19c9aabe47744a5044f3139bcd08d704eac63959cc924636550abd3a1b874"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c9b19c9aabe47744a5044f3139bcd08d704eac63959cc924636550abd3a1b874"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c9b19c9aabe47744a5044f3139bcd08d704eac63959cc924636550abd3a1b874"
    sha256 cellar: :any_skip_relocation, ventura:        "85a601f1d902d893418ffcbe40d1feb1cc12d6039218ac04e26d184f21dacf09"
    sha256 cellar: :any_skip_relocation, monterey:       "85a601f1d902d893418ffcbe40d1feb1cc12d6039218ac04e26d184f21dacf09"
    sha256 cellar: :any_skip_relocation, big_sur:        "85a601f1d902d893418ffcbe40d1feb1cc12d6039218ac04e26d184f21dacf09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9b19c9aabe47744a5044f3139bcd08d704eac63959cc924636550abd3a1b874"
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
