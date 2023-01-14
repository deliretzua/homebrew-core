require "language/node"

class Marked < Formula
  desc "Markdown parser and compiler built for speed"
  homepage "https://marked.js.org/"
  url "https://registry.npmjs.org/marked/-/marked-4.2.11.tgz"
  sha256 "d8ae6a4308413e55ad60b02599259e415dac0624adde298bbf61fff191b8938a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c510be2aac6a8641ea4ed52f7bf0c804e34949fc52d09cd1319a39a528e7227c"
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
