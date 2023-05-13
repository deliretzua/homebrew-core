require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.82.0.tgz"
  sha256 "5a66aa0c8ebe808bc43d7162f02454abba3d8ac4d7426093f160d81c7e35e90c"
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
    sha256                               arm64_ventura:  "d71f43073f5df75c8686400ced828281099c02861278f8de86bf1e1688cc73fd"
    sha256                               arm64_monterey: "02f16dee6ec14e3c2c27b7f01a6289c376f9f08dc2bab051bba37ed65fed6149"
    sha256                               arm64_big_sur:  "1c4b469322b22a6ac4ce964db0accd4c72c0a0d4ba9dcafc39a52bb581ad2633"
    sha256                               ventura:        "113ec5be0223d651e492c30c537e8b44620fa4f045d87a6bb6d3404ca5b6528c"
    sha256                               monterey:       "a3475e46e5cb572d82a4fcd3df4f524180dd66ebf690a4213b29ca7f43a96d51"
    sha256                               big_sur:        "795aa817d787699c9a512d5292d073790554baa93bac5666f39bf319671e9d56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9bab44ab242b0b26e407749a50d4ab69c8a977acc8238a32e4cbac91a28ab7"
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
