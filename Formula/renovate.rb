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
    sha256                               arm64_ventura:  "450cc6037ab1193aefe8fa9b59a264fc7a7ba6bcfc9a35547afd21076d40576d"
    sha256                               arm64_monterey: "42046655f6cb4a9c3d98a9107d0a77e0fac84c082b796c075bf0e299c427145f"
    sha256                               arm64_big_sur:  "8f951d7ee4de3a35a23a809c4b7d0e29fb8bd7a3bec11ce630336c492ef7acf8"
    sha256                               ventura:        "8bde4c4567a4ff0dbf4889baebaa32261582a9a271063745eb6d263b94a77800"
    sha256                               monterey:       "b284f52b858bb14dcec0c7949737a77f5a6474caa07d31e1cd8d8c57062ddeb4"
    sha256                               big_sur:        "3026e261f326a427c39a8094e76d77e4f94809108e6750aff31a919111ee44e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5819a9f332038ca7bc0a90e0b4cb3ed1646ec6f9d31b52585b9bb965df7287e4"
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
