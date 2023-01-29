require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.33.0.tgz"
  sha256 "af9ddf776e572e514713ae8fe4b73f346a041bb548576f7e54eaf65cfd16e07e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "99171c395a4de6fd9bf9225220671b88ed1dbd56c5a3238c13b805071bf178a7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99171c395a4de6fd9bf9225220671b88ed1dbd56c5a3238c13b805071bf178a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99171c395a4de6fd9bf9225220671b88ed1dbd56c5a3238c13b805071bf178a7"
    sha256 cellar: :any_skip_relocation, ventura:        "42a13b7af46b9ba934bfa0915134a50890d2c5420e6007d0f74a15dc5a72fe43"
    sha256 cellar: :any_skip_relocation, monterey:       "42a13b7af46b9ba934bfa0915134a50890d2c5420e6007d0f74a15dc5a72fe43"
    sha256 cellar: :any_skip_relocation, big_sur:        "42a13b7af46b9ba934bfa0915134a50890d2c5420e6007d0f74a15dc5a72fe43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "99171c395a4de6fd9bf9225220671b88ed1dbd56c5a3238c13b805071bf178a7"
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
