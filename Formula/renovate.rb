require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-36.4.0.tgz"
  sha256 "86bb22a86a6be78b432c6a4ee0432f7f817f4337d8766d0a3f47aa77476eb9cf"
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
    sha256                               arm64_ventura:  "8cae36923f8e402d110bd2f1d42c997ff258a32a1bc5c19e45499e3905e5049b"
    sha256                               arm64_monterey: "0098a3cfd093016496ced1b387aa1993765dcddb3a9ce21bb17d3d3a31520447"
    sha256                               arm64_big_sur:  "cd2ca2319ca73632594eb7aae190fe89b4d9bc4b602d1defd862d3ab89191431"
    sha256 cellar: :any_skip_relocation, ventura:        "6b4f20f6487b93b32d232893d9f291c5ad742a2fc7ce74fb917df1d510a8c673"
    sha256 cellar: :any_skip_relocation, monterey:       "b0435bf6542c32490723aed518212e73135d63174c6fec153b574e660b9f82e9"
    sha256 cellar: :any_skip_relocation, big_sur:        "cda313a0bebb525bb686e9f937a7add658753ef79622ce00d40a10b5b71a6988"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0035daff521bc6dffef955def8cbb9c86d61902ce96809766716d1c1db155a82"
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
