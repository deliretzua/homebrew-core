require "language/node"

class Eslint < Formula
  desc "AST-based pattern checker for JavaScript"
  homepage "https://eslint.org"
  url "https://registry.npmjs.org/eslint/-/eslint-8.45.0.tgz"
  sha256 "56f6f570aa125ca9ed6848a0d19247bf1c9050c6b67b7478bd7be7b1d2fef366"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "be9a7b6133fcd754b94d73d37c97e36571c75f29fac945f4b3d7c8a1f22e333a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "be9a7b6133fcd754b94d73d37c97e36571c75f29fac945f4b3d7c8a1f22e333a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "be9a7b6133fcd754b94d73d37c97e36571c75f29fac945f4b3d7c8a1f22e333a"
    sha256 cellar: :any_skip_relocation, ventura:        "5fb483bbc84db5743da0035eac2409c5e0e27b64c4d1051c61318be6e1080e35"
    sha256 cellar: :any_skip_relocation, monterey:       "5fb483bbc84db5743da0035eac2409c5e0e27b64c4d1051c61318be6e1080e35"
    sha256 cellar: :any_skip_relocation, big_sur:        "5fb483bbc84db5743da0035eac2409c5e0e27b64c4d1051c61318be6e1080e35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be9a7b6133fcd754b94d73d37c97e36571c75f29fac945f4b3d7c8a1f22e333a"
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
