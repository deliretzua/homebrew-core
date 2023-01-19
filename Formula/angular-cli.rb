require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.1.2.tgz"
  sha256 "ab8a81ea81c6995f897d4b0aca7c6d14e67e7fb656cd93ce56539d5358a32627"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0f9983b545a0ac181e4796d249559dba0672bec35eed88012755ef6879e7154e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0f9983b545a0ac181e4796d249559dba0672bec35eed88012755ef6879e7154e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0f9983b545a0ac181e4796d249559dba0672bec35eed88012755ef6879e7154e"
    sha256 cellar: :any_skip_relocation, ventura:        "623c47ab594e7e11bd5001d04d5116e2c8024d4c563c2d4ecd3845ac6e00c46e"
    sha256 cellar: :any_skip_relocation, monterey:       "623c47ab594e7e11bd5001d04d5116e2c8024d4c563c2d4ecd3845ac6e00c46e"
    sha256 cellar: :any_skip_relocation, big_sur:        "623c47ab594e7e11bd5001d04d5116e2c8024d4c563c2d4ecd3845ac6e00c46e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f9983b545a0ac181e4796d249559dba0672bec35eed88012755ef6879e7154e"
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
