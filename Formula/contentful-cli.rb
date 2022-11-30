require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.16.10.tgz"
  sha256 "ae2bbbd1c4d7b8d4a042bbc45153b16156c621031bcb57a9a17aef45222f4249"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "583cd5ce36f12ddb14974092013164f2ac76cde5915b926ff69a9d3a2e07fafd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "583cd5ce36f12ddb14974092013164f2ac76cde5915b926ff69a9d3a2e07fafd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "583cd5ce36f12ddb14974092013164f2ac76cde5915b926ff69a9d3a2e07fafd"
    sha256 cellar: :any_skip_relocation, ventura:        "ec469c5e0bd7eeb20f7e91a9a3cdcc8ea71abad7f8211ae200240ca505b44ad5"
    sha256 cellar: :any_skip_relocation, monterey:       "ec469c5e0bd7eeb20f7e91a9a3cdcc8ea71abad7f8211ae200240ca505b44ad5"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec469c5e0bd7eeb20f7e91a9a3cdcc8ea71abad7f8211ae200240ca505b44ad5"
    sha256 cellar: :any_skip_relocation, catalina:       "ec469c5e0bd7eeb20f7e91a9a3cdcc8ea71abad7f8211ae200240ca505b44ad5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "583cd5ce36f12ddb14974092013164f2ac76cde5915b926ff69a9d3a2e07fafd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
