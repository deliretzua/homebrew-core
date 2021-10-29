require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.8.1.tgz"
  sha256 "a96683ba0b5983d705c90588db5f923d428c54f059f5349713f0600337df2596"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "2dac8b96e3fd77533dfcb4d9ec11846b978fc844e6a04d9ddf85e8b7f7b586eb"
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
