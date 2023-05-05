require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.40.0.tgz"
  sha256 "842ea9b31d7667ccb97f3a6a69ad7c957c3a5bc1c344c7bde2727fc7ab12a498"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b35670823fa745f70b6476584431f751e6dcc2dab279ca37a9a07ce39f05a58e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b35670823fa745f70b6476584431f751e6dcc2dab279ca37a9a07ce39f05a58e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b35670823fa745f70b6476584431f751e6dcc2dab279ca37a9a07ce39f05a58e"
    sha256 cellar: :any_skip_relocation, ventura:        "e39c6436e96d82ef4227b9287dbb6c688bb565e6a531a6982cfca7754b848c6f"
    sha256 cellar: :any_skip_relocation, monterey:       "e39c6436e96d82ef4227b9287dbb6c688bb565e6a531a6982cfca7754b848c6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "e39c6436e96d82ef4227b9287dbb6c688bb565e6a531a6982cfca7754b848c6f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b35670823fa745f70b6476584431f751e6dcc2dab279ca37a9a07ce39f05a58e"
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
