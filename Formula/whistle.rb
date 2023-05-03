require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.48.tgz"
  sha256 "63250c0dfdf763dd99c4e410b0ace0ebe3a44be8c5104e99316399b2d9864301"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "32f55e20a5a3d1fee5647bfe0c646b2b760b0c07af0bfe4d6f56237eb329354e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "32f55e20a5a3d1fee5647bfe0c646b2b760b0c07af0bfe4d6f56237eb329354e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "32f55e20a5a3d1fee5647bfe0c646b2b760b0c07af0bfe4d6f56237eb329354e"
    sha256 cellar: :any_skip_relocation, ventura:        "a338b69a536f568ec4284fb451e747b7874d9ec060aa5b9e1285b87e559c5964"
    sha256 cellar: :any_skip_relocation, monterey:       "a338b69a536f568ec4284fb451e747b7874d9ec060aa5b9e1285b87e559c5964"
    sha256 cellar: :any_skip_relocation, big_sur:        "a338b69a536f568ec4284fb451e747b7874d9ec060aa5b9e1285b87e559c5964"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a338b69a536f568ec4284fb451e747b7874d9ec060aa5b9e1285b87e559c5964"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove x86 specific optional feature
    node_modules = libexec/"lib/node_modules/whistle/node_modules"
    rm_f node_modules/"set-global-proxy/lib/mac/whistle" if Hardware::CPU.arm?
  end

  test do
    (testpath/"package.json").write('{"name": "test"}')
    system bin/"whistle", "start"
    system bin/"whistle", "stop"
  end
end
