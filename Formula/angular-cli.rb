require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.2.1.tgz"
  sha256 "9c23ae4bdc8133c72f272e2c2e742c856ad2531735f1f5113f19cbb392da1ee9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb67a0e986a3e854136ee1e261243892b2e9e577b3bd42b6f1a05e668941fc87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bb67a0e986a3e854136ee1e261243892b2e9e577b3bd42b6f1a05e668941fc87"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb67a0e986a3e854136ee1e261243892b2e9e577b3bd42b6f1a05e668941fc87"
    sha256 cellar: :any_skip_relocation, ventura:        "23b0fbe01399b03b314f1f4678ce3242aab72d6c3a8540efb27ae121ca622874"
    sha256 cellar: :any_skip_relocation, monterey:       "23b0fbe01399b03b314f1f4678ce3242aab72d6c3a8540efb27ae121ca622874"
    sha256 cellar: :any_skip_relocation, big_sur:        "23b0fbe01399b03b314f1f4678ce3242aab72d6c3a8540efb27ae121ca622874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb67a0e986a3e854136ee1e261243892b2e9e577b3bd42b6f1a05e668941fc87"
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
