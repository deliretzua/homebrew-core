require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.5.tgz"
  sha256 "d0ed89b7fbf6edddf5217f93b45b291583b390ad2b23f0e862124f462f39b2f1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "93fc52e48bae67c8309c81937096880a794eb9acb87b5fd2a269a7eac25ed9e7"
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
