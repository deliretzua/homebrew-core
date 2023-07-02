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
    sha256                               arm64_ventura:  "0d084d5fc05178119d5e7ff7006896102a56af4ca6ce782eef0ac65ce056a821"
    sha256                               arm64_monterey: "364a3a6f76797e938dad37cc1e7ab5d3da89188fd1c3cf4158a7b9aa1dfe0b0b"
    sha256                               arm64_big_sur:  "ef31fd12dd81268f8180a0d1e5bab12f6f7bfe5258292822597bb93e14b76669"
    sha256 cellar: :any_skip_relocation, ventura:        "70335ba4efb5e286b7bdcfdb0ae7f2f67b920b7bc5c73b630921f478a01c7db1"
    sha256 cellar: :any_skip_relocation, monterey:       "3860696a93477c33117f99c361b4649a61ca1617ea7f722ec3d1e3d87a3af017"
    sha256 cellar: :any_skip_relocation, big_sur:        "04e8d3061fc85b0703db09c817dca0db8eb380bf9df80df9f94998996a15b09c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5ba67e4bc6d4ddfa691e44c5f7577b4f4d61959db7aa925ab74165f1948f02a5"
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
