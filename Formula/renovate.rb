require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.14.0.tgz"
  sha256 "4108489e6e655c80a2ddb7611984dd2192a454b51a3cd94e12ce611246f3c5ab"
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
    sha256                               arm64_ventura:  "cb7fb8313d69e520cec9ff995088fb70ab22761fd726e9dcbb41cf1e102e4e3a"
    sha256                               arm64_monterey: "70cb5a6023418c9a707f18e0b65c15c949cab8e2b2b8caf64ef86e3a4bcbea7c"
    sha256                               arm64_big_sur:  "6a58a4d146a8261921300782a2f18d896da91548375e90191297ae5f86089147"
    sha256 cellar: :any_skip_relocation, ventura:        "366e1a10774447f440c6dab0823f75f3436371fddf04932f4d19826e04a8f1ae"
    sha256 cellar: :any_skip_relocation, monterey:       "17c7b9382ef143269bb908778c1ed050d2dd43fddce970a796a603ddbdde1aa1"
    sha256 cellar: :any_skip_relocation, big_sur:        "68ea7e11d896e1c34830f5ab4d3787a38c9305ea67c08e68c3bdd8205b281976"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1165fcbafb14ace3529a2cb6365c3ea43ab6cdb045477e73cb673444fadd8a98"
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
