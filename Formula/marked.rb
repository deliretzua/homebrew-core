require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-5.1.0.tgz"
  sha256 "2e61fe27531e81c26a3383b6d7473ebbc6ba6fa7369ce4f895533f5719e0873e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "1a32559dfc9b7a4625a64031c93612731065595566086b445e4431bf51fbc7a0"
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
