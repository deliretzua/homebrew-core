require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.113.0.tgz"
  sha256 "3f7d54cb41f00b0bbb53fe639ae2ec7743cb0445c2371f5ea6cbe9c756f0c9e9"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "caf05fe5546ee27d08bc68f1f8109c9ba31332b7c23d144f5102705563f21cb7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d5df6963ee4e9f75c7ad6bad5f957319ccd780178b7cc2f1ee6079e318f811db"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "21cffcea64f15116ec62a495d9bf2e35c9a7a2b357ea11cc3ad3d99f1fc02360"
    sha256 cellar: :any_skip_relocation, ventura:        "7058ead15aee6f355478211813cf54e9fd100e17f6a05609f3233e19dac329c1"
    sha256 cellar: :any_skip_relocation, monterey:       "8676692ec6812cad2f00f02db2a549ab744c9e8937bb7893e1f2d33eec36167b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f4b0f718c83a62f6d54965c7612964dcb7292b3d7644df1a22cbebb7df36dc1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac9a3b7ab940a3ba5d2ed2c68c1a693cc2be28c6eb195f6fd37dfc423d105a9f"
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
