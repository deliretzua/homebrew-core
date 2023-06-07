require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.0.5.tgz"
  sha256 "780201098da330aa2750dab986688172f24650c16403f0b3061370f6ca68b47a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1258d5b551f2e635659ca67602b30724e6890c4a91b9b5dc6f1f28d881a904c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1258d5b551f2e635659ca67602b30724e6890c4a91b9b5dc6f1f28d881a904c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1258d5b551f2e635659ca67602b30724e6890c4a91b9b5dc6f1f28d881a904c8"
    sha256 cellar: :any_skip_relocation, ventura:        "6470f4a2887b3efeb334d77f97301d8b8c3e78c4d55185c223ca7b33bce87a8f"
    sha256 cellar: :any_skip_relocation, monterey:       "6470f4a2887b3efeb334d77f97301d8b8c3e78c4d55185c223ca7b33bce87a8f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6470f4a2887b3efeb334d77f97301d8b8c3e78c4d55185c223ca7b33bce87a8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1258d5b551f2e635659ca67602b30724e6890c4a91b9b5dc6f1f28d881a904c8"
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
