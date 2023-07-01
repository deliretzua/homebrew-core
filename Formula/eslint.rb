require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.44.0.tgz"
  sha256 "57664fc91e6800360e02403bfe7c0e5784a904953f0b86330c35d9b2af1a1cdb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6cf6bddac74235accc1a8af2f8b5f9e87608cfbb4e70d07afeab0c456fd65da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6cf6bddac74235accc1a8af2f8b5f9e87608cfbb4e70d07afeab0c456fd65da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6cf6bddac74235accc1a8af2f8b5f9e87608cfbb4e70d07afeab0c456fd65da"
    sha256 cellar: :any_skip_relocation, ventura:        "74367727879cbbcc3f55fa40dc86801b05f4d04531793326c677dbb33370342b"
    sha256 cellar: :any_skip_relocation, monterey:       "74367727879cbbcc3f55fa40dc86801b05f4d04531793326c677dbb33370342b"
    sha256 cellar: :any_skip_relocation, big_sur:        "74367727879cbbcc3f55fa40dc86801b05f4d04531793326c677dbb33370342b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6cf6bddac74235accc1a8af2f8b5f9e87608cfbb4e70d07afeab0c456fd65da"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".eslintrc.json").write("{}") # minimal config
    (testpath/"syntax-error.js").write("{}}")
    # https://eslint.org/docs/user-guide/command-line-interface#exit-codes
    output = shell_output("#{bin}/eslint syntax-error.js", 1)
    assert_match "Unexpected token }", output
  end
end
