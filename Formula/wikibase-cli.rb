require "language/node"

class WikibaseCli < Formula
  desc "Command-line interface to Wikibase"
  homepage "https://github.com/maxlath/wikibase-cli#readme"
  url "https://registry.npmjs.org/wikibase-cli/-/wikibase-cli-16.3.2.tgz"
  sha256 "fb37f93eb5a08352fd9b6a0b1643532d52b85517e0d20073bf084b6969cf79f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d17ee440a1c72ad942cd30e3e55fa124cdf529364ec48020381cee3afe00cb3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7d17ee440a1c72ad942cd30e3e55fa124cdf529364ec48020381cee3afe00cb3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d17ee440a1c72ad942cd30e3e55fa124cdf529364ec48020381cee3afe00cb3"
    sha256 cellar: :any_skip_relocation, ventura:        "b4a8ed6699627ec3267ebb92021e7a29ab19e0d4debc22861e27bf28d0ebb3ab"
    sha256 cellar: :any_skip_relocation, monterey:       "b4a8ed6699627ec3267ebb92021e7a29ab19e0d4debc22861e27bf28d0ebb3ab"
    sha256 cellar: :any_skip_relocation, big_sur:        "b4a8ed6699627ec3267ebb92021e7a29ab19e0d4debc22861e27bf28d0ebb3ab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7d17ee440a1c72ad942cd30e3e55fa124cdf529364ec48020381cee3afe00cb3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "human", shell_output("#{bin}/wd label Q5 --lang en").strip
  end
end
