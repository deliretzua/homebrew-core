require "language/node"

class Aicommits < Formula
  desc "Writes your git commit messages for you with AI"
  homepage "https://github.com/Nutlope/aicommits"
  url "https://registry.npmjs.org/aicommits/-/aicommits-1.8.2.tgz"
  sha256 "97ae1d6efc84377170a4e551f0ab92c3fb6547ee3ae4c255db278aaa71afd13e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "f17b548facc6940755e901f505d9e32d4ed6f3d46ffc53908bda1286af5c8cec"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "The current directory must be a Git repository!", shell_output("#{bin}/aicommits", 1)

    system "git", "init"
    assert_match "No staged changes found. Stage your changes manually, or automatically stage all changes with the",
      shell_output("#{bin}/aicommits", 1)
    touch "test.txt"
    system "git", "add", "test.txt"
    assert_match "Please set your OpenAI API key via `aicommits config set OPENAI_KEY=<your token>`",
      shell_output("#{bin}/aicommits", 1)
  end
end
