require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.43.0.tgz"
  sha256 "7a57d459b0799eba1687cf69de637aceac102fe797ce43cab95c24d51da0c295"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2a057d25044bccc45f85af4548802243989548bc1357c1fe8dc8a01018419e12"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2a057d25044bccc45f85af4548802243989548bc1357c1fe8dc8a01018419e12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a057d25044bccc45f85af4548802243989548bc1357c1fe8dc8a01018419e12"
    sha256 cellar: :any_skip_relocation, ventura:        "d1995a5f5e9645d4142bcfd9b7fe50cdbd5b6b7340436592a03a31f6f674a5e3"
    sha256 cellar: :any_skip_relocation, monterey:       "d1995a5f5e9645d4142bcfd9b7fe50cdbd5b6b7340436592a03a31f6f674a5e3"
    sha256 cellar: :any_skip_relocation, big_sur:        "d1995a5f5e9645d4142bcfd9b7fe50cdbd5b6b7340436592a03a31f6f674a5e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a057d25044bccc45f85af4548802243989548bc1357c1fe8dc8a01018419e12"
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
