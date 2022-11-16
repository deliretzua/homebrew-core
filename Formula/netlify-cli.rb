require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.2.0.tgz"
  sha256 "9d2095e40472558c8605a465492bef94d173a93f959e98f8191cca4cc56631d9"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "393705b323e536dc5e24b7f7cadbc890eea12e0d2254a96daa1a9dc07cc850df"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "393705b323e536dc5e24b7f7cadbc890eea12e0d2254a96daa1a9dc07cc850df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "393705b323e536dc5e24b7f7cadbc890eea12e0d2254a96daa1a9dc07cc850df"
    sha256 cellar: :any_skip_relocation, monterey:       "90a8255648a257589573f15a0b36386a4a0883c846c988435586e847b1fdd659"
    sha256 cellar: :any_skip_relocation, big_sur:        "90a8255648a257589573f15a0b36386a4a0883c846c988435586e847b1fdd659"
    sha256 cellar: :any_skip_relocation, catalina:       "90a8255648a257589573f15a0b36386a4a0883c846c988435586e847b1fdd659"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcc433862547fd2d47f0a7f78848b2391e105d4ecaa45026658426606ab09db1"
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
