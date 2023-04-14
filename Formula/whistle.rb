require "language/node"

class Whistle < Formula
  desc "HTTP, HTTP2, HTTPS, Websocket debugging proxy"
  homepage "https://github.com/avwo/whistle"
  url "https://registry.npmjs.org/whistle/-/whistle-2.9.46.tgz"
  sha256 "07bb48144c215f582093dee6b206fb23e0a30ffeb728ae98cc2f6c6a84a12623"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "541e2d1730f825ba5b61d107ccda3a1f57ca42d3aa1f92a9e0e3a1f04cedc926"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "541e2d1730f825ba5b61d107ccda3a1f57ca42d3aa1f92a9e0e3a1f04cedc926"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "541e2d1730f825ba5b61d107ccda3a1f57ca42d3aa1f92a9e0e3a1f04cedc926"
    sha256 cellar: :any_skip_relocation, ventura:        "10d6ff43c7d092ad73d754c7889f8b2d2892ad1e9c0402ec6caaae22640f6165"
    sha256 cellar: :any_skip_relocation, monterey:       "10d6ff43c7d092ad73d754c7889f8b2d2892ad1e9c0402ec6caaae22640f6165"
    sha256 cellar: :any_skip_relocation, big_sur:        "10d6ff43c7d092ad73d754c7889f8b2d2892ad1e9c0402ec6caaae22640f6165"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "10d6ff43c7d092ad73d754c7889f8b2d2892ad1e9c0402ec6caaae22640f6165"
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
