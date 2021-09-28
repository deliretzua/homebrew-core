require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.24.tgz"
  sha256 "65d04e031ad9397903d2a14758fc70c84b0924a6bce854eebf7e63a7c7dab56c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2593eff42e7591e80145af7c12c9098f9892f9a84ba91eba18ca697a581bbe36"
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
