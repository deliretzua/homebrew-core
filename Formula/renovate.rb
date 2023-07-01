require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.154.0.tgz"
  sha256 "a3be5fe12baaf48a4da9ec580b9a94433f67af556a4d5f8e062a1b4ce0e75c63"
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
    sha256                               arm64_ventura:  "2d93d69b0d563a945e161b3e9f85db326a64065f3bb0ab44f2c6fe7d35da1f0b"
    sha256                               arm64_monterey: "8dcde557ab62c433e9dcf4b1819f7610c84339d63efa9013b53ea7207a3cda74"
    sha256                               arm64_big_sur:  "a2effcf6b763d53cb0f1caf5dcad88b429710bfcd725aaa4a8cee7202c7b6a02"
    sha256 cellar: :any_skip_relocation, ventura:        "7002ff9b9f067651501583fca070dccc60742b65b7c4ee055a6286d5a0945cb7"
    sha256 cellar: :any_skip_relocation, monterey:       "fdf1ce723553ad1f3230e61302df0e9c3e7155eeae0af3cb59a432db0284969b"
    sha256 cellar: :any_skip_relocation, big_sur:        "51a8570a40053a4feceb9d087c205b1a4752593e29806f807f747b904297bb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2d9aaa6d979c2f6382adac8350608d1abdc49a02ba30071921d774831da23c02"
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
