require "language/node"

class Stylelint < Formula
  desc "Modern CSS linter"
  homepage "https://stylelint.io/"
  url "https://registry.npmjs.org/stylelint/-/stylelint-14.16.1.tgz"
  sha256 "f968356f0e32a7dab460703c1e795bb01c12a85f62258049100efa9af7c595a8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "512040b666723adbdca1a148bc5049d15ff7bd2bee519954589bde116a08632c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "512040b666723adbdca1a148bc5049d15ff7bd2bee519954589bde116a08632c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "512040b666723adbdca1a148bc5049d15ff7bd2bee519954589bde116a08632c"
    sha256 cellar: :any_skip_relocation, ventura:        "cabde427797bd587f393b29b70e037b5ba296ba461cd34786e2818a377acf29c"
    sha256 cellar: :any_skip_relocation, monterey:       "cabde427797bd587f393b29b70e037b5ba296ba461cd34786e2818a377acf29c"
    sha256 cellar: :any_skip_relocation, big_sur:        "cabde427797bd587f393b29b70e037b5ba296ba461cd34786e2818a377acf29c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "512040b666723adbdca1a148bc5049d15ff7bd2bee519954589bde116a08632c"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/".stylelintrc").write <<~EOS
      {
        "rules": {
          "block-no-empty": true
        }
      }
    EOS

    (testpath/"test.css").write <<~EOS
      a {
      }
    EOS

    output = shell_output("#{bin}/stylelint test.css 2>&1", 2)
    assert_match "Unexpected empty block", output

    assert_match version.to_s, shell_output("#{bin}/stylelint --version")
  end
end
