require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-7.0.1.tgz"
  sha256 "6021085193dfb48ac4b15a467534bb924af0a46f40edc2bf03a926cf01ad4992"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "29a96978d3db87ef0e27c53760b60db99623ab6c34733c1748fea9f0c2689759"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "29a96978d3db87ef0e27c53760b60db99623ab6c34733c1748fea9f0c2689759"
    sha256 cellar: :any_skip_relocation, monterey:       "9bcd489164fe798bb877c5511054b2019a903401e545dc91f4d01849eab94753"
    sha256 cellar: :any_skip_relocation, big_sur:        "9bcd489164fe798bb877c5511054b2019a903401e545dc91f4d01849eab94753"
    sha256 cellar: :any_skip_relocation, catalina:       "9bcd489164fe798bb877c5511054b2019a903401e545dc91f4d01849eab94753"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "29a96978d3db87ef0e27c53760b60db99623ab6c34733c1748fea9f0c2689759"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
