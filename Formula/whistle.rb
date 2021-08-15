require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.14.tgz"
  sha256 "5b6e3734f5c9b904e6a882c8e1b4a881b4e44570782719eb44f75421aed29cba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ab9febfd8f8eb9b61368af54aa4cc371d4ce2b07e39631a32d3f9789a263d053"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
