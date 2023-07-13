require "language/node"

class Neonctl < Formula
  desc "Neon CLI tool"
  homepage "https://neon.tech/docs/reference/neon-cli"
  url "https://registry.npmjs.org/neonctl/-/neonctl-1.17.2.tgz"
  sha256 "dbd18883ac9da3609878d1f986e383e251c9a4246069e7f22f1e89d16db01ba5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5046f4aea3c1a9c86c66fdeefd97813c4cddbd74635a33d8264cc158da544512"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5046f4aea3c1a9c86c66fdeefd97813c4cddbd74635a33d8264cc158da544512"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5046f4aea3c1a9c86c66fdeefd97813c4cddbd74635a33d8264cc158da544512"
    sha256 cellar: :any_skip_relocation, ventura:        "58d84014441f1681c3a90adefab360475d3cd7d3507af9c8f178ffae19a56e26"
    sha256 cellar: :any_skip_relocation, monterey:       "58d84014441f1681c3a90adefab360475d3cd7d3507af9c8f178ffae19a56e26"
    sha256 cellar: :any_skip_relocation, big_sur:        "58d84014441f1681c3a90adefab360475d3cd7d3507af9c8f178ffae19a56e26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5046f4aea3c1a9c86c66fdeefd97813c4cddbd74635a33d8264cc158da544512"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/neonctl --api-key DOES-NOT-EXIST projects create 2>&1", 1)
    assert_match("Authentication failed,", output)
  end
end
