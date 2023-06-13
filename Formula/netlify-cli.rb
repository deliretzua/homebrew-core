require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.5.0.tgz"
  sha256 "c756e26412502dec3f10936d0089acf57fe9a20c682301bc4a1ff5731692919b"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "549684189b3eb14d578641a1638d372b0b9b1a6273c3b5e94a6b8c37c6bbb2c0"
    sha256                               arm64_monterey: "8ecebb1cef2b296c6fa47fede10ba328ad2e54903a2d830c9179e0ea4a9fe400"
    sha256                               arm64_big_sur:  "e1c695caaa641cdace5d20d88d28d4ded297ffe0824f73e2bdcf49c2043b0221"
    sha256                               ventura:        "124a2a1e8fe177a8a10dc67451ea851853a19d164addb2f9149f15795daa96d9"
    sha256                               monterey:       "664cb9ca5a0ed06957a83a15494898384477c67bfa60b003c99557a7b2860f6f"
    sha256                               big_sur:        "7bbb6df7d5368c1323e464f0222bd83fdab7dc9a9564819f02f60165e2892866"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40fee0fe32a4b02cef3a1581dfd8c73d9453f05a6972bf3acc37944e99c0596d"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
