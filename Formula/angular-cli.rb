require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.1.3.tgz"
  sha256 "1d0af05445be6a639de958304c44ee8a06e5a0993383486c76d2b6fa16b493ff"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da373db44fc1fb855d5b7eb085261da5958e43e229910be0bfb9bdac50480f97"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da373db44fc1fb855d5b7eb085261da5958e43e229910be0bfb9bdac50480f97"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "da373db44fc1fb855d5b7eb085261da5958e43e229910be0bfb9bdac50480f97"
    sha256 cellar: :any_skip_relocation, ventura:        "8dabe1154af92a6c07d67c572609624e391836b0b63b2839d8bf8a94cb1c37f1"
    sha256 cellar: :any_skip_relocation, monterey:       "8dabe1154af92a6c07d67c572609624e391836b0b63b2839d8bf8a94cb1c37f1"
    sha256 cellar: :any_skip_relocation, big_sur:        "8dabe1154af92a6c07d67c572609624e391836b0b63b2839d8bf8a94cb1c37f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da373db44fc1fb855d5b7eb085261da5958e43e229910be0bfb9bdac50480f97"
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
