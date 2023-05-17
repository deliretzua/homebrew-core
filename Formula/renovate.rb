require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.92.0.tgz"
  sha256 "0f272f61f54b3ad21bc9c1483c480bce44d246d16f34c34d208de045346c1b5f"
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
    sha256                               arm64_ventura:  "23b2dcbab36191c3158ce73ab46864dde30e60d13957b19c262983f64a0bc7be"
    sha256                               arm64_monterey: "e0111f4a2f0c4e3ce435598d9667514678486efbad4f59dbd36c35948e758e2e"
    sha256                               arm64_big_sur:  "eb625f45d4cda7a9856c3576ac993b21ee6c6a9e6561140ee82d0c06c5c43f85"
    sha256                               ventura:        "dd082d95df62169705454c2aab9779faaeed9c31f977de7a984cdf1db6c2dc0c"
    sha256                               monterey:       "94891a2046cf86119f7249b711a3c966840279086527f8062cf8086dda154595"
    sha256                               big_sur:        "21ffb3c7c406a895e25957c7b9919ae6b7f616046e6615e384ef6d60add91399"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64952e4f7e4815d86a2b848ce9de5b6718cbbd9c62eee2d54d82b39ecbbe1ab2"
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
