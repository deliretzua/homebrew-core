require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.148.0.tgz"
  sha256 "40f780ec1eabe8b9cd161ba4a08e67408997e9cefef1179a7710fa918c7e159e"
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
    sha256                               arm64_ventura:  "2cf72428a6ee69cbc2d7d2b37091b3c3be856e10d5113d48a034381a1efc8099"
    sha256                               arm64_monterey: "d0d8ab67571d57a4d2d0bfc5404a7b1dfa11a8ed6f72447d908bdea7c7bcae90"
    sha256                               arm64_big_sur:  "e1555d81f6274b75bde7baccda94dcf837321a68f70f888e53e97721238f1d7a"
    sha256 cellar: :any_skip_relocation, ventura:        "6e8adcb702215ca9bedacff34f35303824794a565a5e1a02041eaff89c0534a1"
    sha256 cellar: :any_skip_relocation, monterey:       "a5d0c11c60aceec1484039d5b5a3f244625f510b987bf74eb0536990748b9417"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d8968adbc20757abbacc454dc4b05e7613b6fdd823c7f08c9de52e033b187e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c80112a4e6b14b368ec956bf260647df9d6cd58a27b73b9f57a0506f3b206c82"
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
