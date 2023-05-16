require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.89.0.tgz"
  sha256 "67b5b3aadbae66ce436ba4c2551e2c299b1253b844b3e98e58cb4f4e3a15efc7"
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
    sha256                               arm64_ventura:  "55357ab9b33a2e35453631f3a8b511b8f68d44d1398be5d89db55574dc2db96f"
    sha256                               arm64_monterey: "1c8edda56d64786781f4fb28ad18e31bbf31743a1cefbd6ccd675002fa2b90e8"
    sha256                               arm64_big_sur:  "5df6bc92684e05c525566374cbe73cddcfe3fef5df05441b18d2b2963d14834b"
    sha256                               ventura:        "fbbe03087aef86ec2ed34f9ab0fcd548c46053716d19e0db76844a2ebfccdd57"
    sha256                               monterey:       "80e28d59e34d56c4d95acc467473cadccb67d2138587b64574adb5da9c4d2148"
    sha256                               big_sur:        "8fdf71e1f58cfdb3a0d2223942b50171d858ba8b83c209d9ab2c12b26e5a4c4a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aa9bf188408fac483569a67a254c806d554b90832d47f9f0bd5ff82280baea00"
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
