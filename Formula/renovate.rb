require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.3.0.tgz"
  sha256 "5adf49ac9a5c112e92507999914553f6bad0c71ebe820b95f210fb38007ff01d"
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
    sha256                               arm64_ventura:  "57c6cc72a542876a8e8b8355efd73f6231492f8bee2628d4f7b119432354f894"
    sha256                               arm64_monterey: "0f43914a4415b2c988568906f829467f6ed53338d48cf49105a85d0e2e646229"
    sha256                               arm64_big_sur:  "9f4fbb67d1735e9b53f1009e0f0ec1cab2363d2b2d4f9f2b23068d3cb703f546"
    sha256 cellar: :any_skip_relocation, ventura:        "a498e4d7755217327b6e7e39ddefda0dbc024bb190967a0fad99679411d29733"
    sha256 cellar: :any_skip_relocation, monterey:       "65d578df7546fdfa8511f79648812902eae0e779255a000ecf6b10492137b1ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "ee84f9971077b707446158f9075ccdbeb7ac43bd47b696993a67664d673c76a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "09414b707448dca0623725f14f7a0d4e7beb87b93b6a258fd973592b2f3f5538"
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
