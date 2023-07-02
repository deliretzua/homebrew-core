require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.157.0.tgz"
  sha256 "de5861337df51248df4dc48c169d517a4d0a1fb471adbc8ccaa19b44df00d323"
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
    sha256                               arm64_ventura:  "00129bd115287bd564298df504086cd68b9b74c006156d9348f8de3e02e81d7b"
    sha256                               arm64_monterey: "5f567fee4e9cf72efaff56e72a66dc50a38882c91a93aceb8e9b5dd2c75697bf"
    sha256                               arm64_big_sur:  "8806d0e94672fe6eb9b79af6fe7c34e4b1e8304a534e8b254efc1819a0e6fbf6"
    sha256 cellar: :any_skip_relocation, ventura:        "0be985e861f99cb9cf8d1552630a2d5cb1a1ff4666ef165d4401e2280e6b7fab"
    sha256 cellar: :any_skip_relocation, monterey:       "78fc1da73ca88fbe09a68cb0dc4d2995b7c293c45cb7b87bf19848861debf2b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "374d84c21a0ff3e4e2c3b8e65876cb4f2e3cc5df79ed824420f69b735ea1f56c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7f715a0b12f7e04cb8cf2403df8a378dc6dac0f66bd96eea137b7a091837e28e"
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
