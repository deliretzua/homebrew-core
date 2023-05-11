require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.0.1.tgz"
  sha256 "327e8bc18feae047f2938fd1a1e2a0791a4b2bb006f8241a6bc63181e4800464"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1702024f94321757ed18ca7beb7dc0cf28271576a1bcfc129af3f627b2bccadd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1702024f94321757ed18ca7beb7dc0cf28271576a1bcfc129af3f627b2bccadd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1702024f94321757ed18ca7beb7dc0cf28271576a1bcfc129af3f627b2bccadd"
    sha256 cellar: :any_skip_relocation, ventura:        "a588bcad94e79020d3935b24c2572d547a68f1cbdc48bbf9dc1aa57b851d75e2"
    sha256 cellar: :any_skip_relocation, monterey:       "a588bcad94e79020d3935b24c2572d547a68f1cbdc48bbf9dc1aa57b851d75e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "a588bcad94e79020d3935b24c2572d547a68f1cbdc48bbf9dc1aa57b851d75e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1702024f94321757ed18ca7beb7dc0cf28271576a1bcfc129af3f627b2bccadd"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
