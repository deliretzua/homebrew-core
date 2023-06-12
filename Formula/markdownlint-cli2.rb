require "language/node"

class MarkdownlintCli2 < Formula
  desc "Fast, flexible, config-based cli for linting Markdown/CommonMark files"
  homepage "https://github.com/DavidAnson/markdownlint-cli2"
  url "https://registry.npmjs.org/markdownlint-cli2/-/markdownlint-cli2-0.8.1.tgz"
  sha256 "c29ad1e732243dd84705e66f9f7f2cd9bcf45eb8f4fe3c6d3a275a16adb3b27d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7694b45e6d5655fbfa042e89e614e929d6cf5c443d2566ac4a26adae42e704b2"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test-bad.md").write <<~EOS
      # Header 1
      body
    EOS
    (testpath/"test-good.md").write <<~EOS
      # Header 1

      body
    EOS
    assert_match "Summary: 1 error(s)",
      shell_output("#{bin}/markdownlint-cli2 :#{testpath}/test-bad.md 2>&1", 1)
    assert_match "Summary: 0 error(s)",
      shell_output("#{bin}/markdownlint-cli2 :#{testpath}/test-good.md")
  end
end
