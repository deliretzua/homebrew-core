require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.109.0.tgz"
  sha256 "8d5bbcdf68a4ff1765a9611bc39af05acf5ab4166bd3be74093787e840e9407e"
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
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ccd26a59db90bfde92193c0431fc2e9a9d2ae945d37f1ec3fa621a46f7559fec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "babe3bd81c91aead5222724f9f13b2d53f7d77a5b614c9367f96655d4743c322"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3963f43119e926d7a090bf9b36fcdd75f07cc1a337c7daef6045996cf85989b"
    sha256 cellar: :any_skip_relocation, ventura:        "ae8a841d654d1739bc717476f43a798365bef2198ed2d03532c4aeb012df6d95"
    sha256 cellar: :any_skip_relocation, monterey:       "893bace9229c8874137b98432b9cbb026f2862f5884c96b74e65358f039b5673"
    sha256 cellar: :any_skip_relocation, big_sur:        "0654ca628f3f4b1cadc275f2a4b5a92c790e8caf5a76dfba8a91cbacd960f93e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76f20a201e43d416b16c79326695419f295816f535edee5c043b6f878784ca31"
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
