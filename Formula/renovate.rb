require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.102.0.tgz"
  sha256 "ae9e38f17098c4f4220476372325a34360e20e71b3196ef781a5ffbc64e94783"
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
    sha256                               arm64_ventura:  "39447af7a8ec03b3adbc1af4f59cbed82deb3159dc8c20ccb74c923dc2dd3fe6"
    sha256                               arm64_monterey: "2fa96124dd933b2195838f7e3e5b0a0d5a16156aab0d17aee6d63dcd157e80f5"
    sha256                               arm64_big_sur:  "42126f1053c3c109c7d0843c7d8f9b920424a6a6c5f98813feeb5c3f1d1a0163"
    sha256                               ventura:        "26dce472a389827b334ed597adb21dc95854f1341c3258baefed121571a2275f"
    sha256                               monterey:       "cd8250640ec279721c78f8c4e7d46a3b807f958af3d67c9eb67fcf12fca65107"
    sha256                               big_sur:        "f04e96e237e0e0cc9e6e255c9cbe5e0341d47890c1e3326a5eb53d4c8a990716"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d87c98cb93b9355c5b4257270dd41918e81f31742fa17510be1554a98412d364"
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
