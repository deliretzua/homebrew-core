require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.128.0.tgz"
  sha256 "3bf35af508481ebf8fbabd2d7f983c8735a3f6f3f0a29777b49f1a2614d076b0"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e9604e8ef4fff6a80f70487e48f98b682054eea83af404ebe03c355f611ac18f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f1ca97c830cedbba011a3162ea0243dced30433e60d0577b021d20afbe7fb45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c28cb8533f135cc23c9cb8b2e62c2f0f2a930360708f922383d92b93ec786c03"
    sha256 cellar: :any_skip_relocation, ventura:        "54bc7948e1e5a21685bb385f2f022c9a0b5644278b7bc71398fbac93e9594f00"
    sha256 cellar: :any_skip_relocation, monterey:       "643dd26535e953e811a3593e776210c4e40b779a283757ae0f2f19dfff8deb1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1920c34108571c64b6e53d361653b59f9a5a2efa37502b102154a8da2647591"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "827d35c7af679d12c86d4e7273a3b93c342b0a1184290abdcaf7cf6f82ebcdf1"
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
