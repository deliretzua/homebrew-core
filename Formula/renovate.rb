require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.146.0.tgz"
  sha256 "d19c7ed4a802a4c3ebc8ace2d653cc71f9b595735be30c8b8e789e1b7903c58b"
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
    sha256                               arm64_ventura:  "76c2a75e2c69335c841c86890e976c4bd06671cdfd41939633093e393ea803fa"
    sha256                               arm64_monterey: "7c0cc1743ea41349ee1b8231125903710b8806da42fd0bd9ff51c43401124cc4"
    sha256                               arm64_big_sur:  "0ea6cf5bc6b78bd7afd185aed4b25c538e101bbb92961f7228aa501e0a42aa0b"
    sha256 cellar: :any_skip_relocation, ventura:        "62dca9d96728dd5d25d56fde097b0ae7f89b34ce29e0787fc54c9cbcff1e513a"
    sha256 cellar: :any_skip_relocation, monterey:       "baca3ca3613ec5716c39de0dafa5ec157f74eee15316a3c28c72f84efbc21e9b"
    sha256 cellar: :any_skip_relocation, big_sur:        "29309651b4ec2c7aecaac06476eeb794748082add1f58d5b812d6746c1342bf9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f66131e394753cf53eea052eb14cdec7bf5fa652ca9f919c6d60fa954ea2d107"
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
