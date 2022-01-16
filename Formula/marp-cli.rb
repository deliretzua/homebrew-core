require "language/node"

class MarpCli < Formula
  desc "Easily convert Marp Markdown files into static HTML/CSS, PDF, PPT and images"
  homepage "https://github.com/marp-team/marp-cli"
  url "https://registry.npmjs.org/@marp-team/marp-cli/-/marp-cli-1.5.1.tgz"
  sha256 "d6382fe7dfa477d4a7540fa7e0fc4af3119cb1bcf9cec8e5817b22f7f52772e8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "57c00c570a3cd0ea2f2e87150d2e65721d76eaa37c7abd3af226d9c97157d7cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57c00c570a3cd0ea2f2e87150d2e65721d76eaa37c7abd3af226d9c97157d7cf"
    sha256 cellar: :any_skip_relocation, monterey:       "940d413e38d4eadb69a456ad6c83f6754f13c14190e372a7b9b736091b9d0eeb"
    sha256 cellar: :any_skip_relocation, big_sur:        "940d413e38d4eadb69a456ad6c83f6754f13c14190e372a7b9b736091b9d0eeb"
    sha256 cellar: :any_skip_relocation, catalina:       "940d413e38d4eadb69a456ad6c83f6754f13c14190e372a7b9b736091b9d0eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f202aa54a46f7d8db6c09f2461d31d2858ac83973bdf0ec9a1faf75e8993b48f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"deck.md").write <<~EOS
      ---
      theme: uncover
      ---

      # Hello, Homebrew!

      ---

      <!-- backgroundColor: blue -->

      # <!--fit--> :+1:
    EOS

    system "marp", testpath/"deck.md", "-o", testpath/"deck.html"
    assert_predicate testpath/"deck.html", :exist?
    content = (testpath/"deck.html").read
    assert_match "theme:uncover", content
    assert_match "<h1>Hello, Homebrew!</h1>", content
    assert_match "background-color:blue", content
    assert_match "👍", content
  end
end
