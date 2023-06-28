require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.1.2.tgz"
  sha256 "bbf8c2ae97c9a5521c8d8816344f7d9104eb2f30dcc35705bdb0ca2c3a4cb7ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "230c95dea49346860f20b91ae88083a17b72b24a1f763515fb1aff737e7685b4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "230c95dea49346860f20b91ae88083a17b72b24a1f763515fb1aff737e7685b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "230c95dea49346860f20b91ae88083a17b72b24a1f763515fb1aff737e7685b4"
    sha256 cellar: :any_skip_relocation, ventura:        "900e38c6e555ce0bb620e343f6a082d9b50f98477e8bd11ec3bc1f35931e9159"
    sha256 cellar: :any_skip_relocation, monterey:       "900e38c6e555ce0bb620e343f6a082d9b50f98477e8bd11ec3bc1f35931e9159"
    sha256 cellar: :any_skip_relocation, big_sur:        "900e38c6e555ce0bb620e343f6a082d9b50f98477e8bd11ec3bc1f35931e9159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "230c95dea49346860f20b91ae88083a17b72b24a1f763515fb1aff737e7685b4"
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
