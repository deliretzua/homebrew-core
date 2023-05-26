require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-5.0.3.tgz"
  sha256 "171d0685721944c1d5b0adf5ff66bc9cdbb3b8044900acfc33a14cf28acf6e27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "682e312600e67d03746fdb4f5f290f5483af86559fa4486e966f7f5e7200e3f3"
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
