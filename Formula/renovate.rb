require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.124.0.tgz"
  sha256 "be2389dc6b854f55bc70f790008a1223f17895a2be2c8e5146d6fbdfa964792d"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4e9ce7b70c3fd68e866a00dcbf1abf03197f0400615c33693c2f2fd15c7cb9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6c94c8a150ef9f215538a23f39aff5476cf65aa1ee05cb09c475b387f0f55956"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6b01eca3cd56ad75b3109c212527c2550f3929e9b98b47d2cf9685b57beada58"
    sha256 cellar: :any_skip_relocation, ventura:        "0edaf67ba7b1d3d809529e81a08abd3e9598d653cb429952015713542abe1ca8"
    sha256 cellar: :any_skip_relocation, monterey:       "cbd9835dc2c16c4a8dcb464f3327847f1e382ace0f3aa92d4b7612939da4aca6"
    sha256 cellar: :any_skip_relocation, big_sur:        "899a827f5ecb79f19649c6476d2e5cdaaaa0f251e0dab601131fb3d1a8b00f83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dea17dd71c7597081b19e95000844cfeac41aae44e6fb7b0256c49251dcf139b"
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
