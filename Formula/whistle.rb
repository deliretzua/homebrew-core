require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.7.8.tgz"
  sha256 "641922086d150ef6d9c9ebf51d30a5e7c6386739ae3d0dbc123ac3636f987dba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "24ed92d2b453af43bb0dd3f49f8429408cf1a6f700900f72eb2292212422b70c"
    sha256 cellar: :any_skip_relocation, all:          "c1d8f782272048f6d7d0c2cf236a902a0e19c423c7e0752fcaa2041b1c33d976"
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
