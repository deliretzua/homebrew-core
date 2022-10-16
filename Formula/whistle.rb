require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.32.tgz"
  sha256 "ac1389960fc92fa1087fa81ff9b3fe784c4a0c7cc47600be0f9ee04dd6f86b27"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "8713d119300a5c65f7566e8ea79ff68defbacc69207a18da04cf6ddd8b9f587e"
  end

  # `bin/proxy/mac/Whistle` was only built for `x86_64`
  # upstream issue tracker, https://github.com/avwo/whistle/issues/734
  depends_on arch: :x86_64
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
