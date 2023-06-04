require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.52.tgz"
  sha256 "181e11c46876740f20384985fa18a795b55573556b480295cf1ba3263513fc23"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4bd8b5b0b7b61d4599bead482265f8d831ef11db9425da06092043fb8de21222"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4bd8b5b0b7b61d4599bead482265f8d831ef11db9425da06092043fb8de21222"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4bd8b5b0b7b61d4599bead482265f8d831ef11db9425da06092043fb8de21222"
    sha256 cellar: :any_skip_relocation, ventura:        "009d0d07275ab9bcd5229c17500f529050b80ca40e45e0414fe0e652c7cb2c7c"
    sha256 cellar: :any_skip_relocation, monterey:       "009d0d07275ab9bcd5229c17500f529050b80ca40e45e0414fe0e652c7cb2c7c"
    sha256 cellar: :any_skip_relocation, big_sur:        "009d0d07275ab9bcd5229c17500f529050b80ca40e45e0414fe0e652c7cb2c7c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "009d0d07275ab9bcd5229c17500f529050b80ca40e45e0414fe0e652c7cb2c7c"
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
