require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-5.1.2.tgz"
  sha256 "3f0d89700e0a1815dae5856f398a59ddd87898f759e7f5232f8937c5d1f6a69e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "56d437a6a82f032e11768ea435d325320ba9f3c01bdfb5ee0994a8bf9d46c395"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "<p>hello <em>world</em></p>", pipe_output("#{bin}/marked", "hello *world*").strip
  end
end
