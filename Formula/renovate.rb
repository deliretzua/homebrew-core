require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.107.0.tgz"
  sha256 "4f110c020476504a6bc675b16d85b32dca58e423434f75d2b3733a0f163f9bc2"
  license "AGPL-3.0-only"

  # There are thousands of renovate releases on npm and page the `Npm` strategy
  # checks is several MB in size and can time out before the request resolves.
  # This checks the "latest" release, which doesn't have the same issues.
  livecheck do
    url "https://registry.npmjs.org/renovate/latest"
    regex(/v?(\d+(?:\.\d+)+)/i)
    strategy :json do |json, regex|
      json["version"]&.scan(regex) { |match| match[0] }
    end
  end

  bottle do
    sha256                               arm64_ventura:  "629e50386ba71973e3559289bd2f0edfd5912a0b273fc5b1e8ac49704f3e5269"
    sha256                               arm64_monterey: "e313c3541c3de34dbc56ad00c0e4fe6ce7784c3a5c90e796a1ff4448c82194d8"
    sha256                               arm64_big_sur:  "eaf8c8cd71a926e9d226f95ddc6aea9283c15ff77b1493d02db8aad625dc3c5e"
    sha256                               ventura:        "13cd1b13c242b23716767d032952f8861d4988fa402ac81438964d16eb87459e"
    sha256                               monterey:       "4d7f77e4f7495cafdd78684af0eb4ff697915e014fadae943a0120b1ba879476"
    sha256                               big_sur:        "f1ff9456145d8e87ee6ba927b65dc60086bbbe1e41b51ae27ea44b61f8088861"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25fd4e1c54b7548bbccabdc6fde33b44199b52441ce7def86eba5bc34ec23669"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
