require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.1.0.tgz"
  sha256 "fc320c75ba802ce9e6c8512e88507175f2a4ec4ee72d3294e22912477693b01f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fe19e597869893b7af6473102e80677240e827008443ba17da755beace6fe11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fe19e597869893b7af6473102e80677240e827008443ba17da755beace6fe11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fe19e597869893b7af6473102e80677240e827008443ba17da755beace6fe11"
    sha256 cellar: :any_skip_relocation, ventura:        "7cabb11ed9df4a0b48ae71b1bfb3557d66637a9b36250ee7768b03f1b850cf42"
    sha256 cellar: :any_skip_relocation, monterey:       "7cabb11ed9df4a0b48ae71b1bfb3557d66637a9b36250ee7768b03f1b850cf42"
    sha256 cellar: :any_skip_relocation, big_sur:        "7cabb11ed9df4a0b48ae71b1bfb3557d66637a9b36250ee7768b03f1b850cf42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fe19e597869893b7af6473102e80677240e827008443ba17da755beace6fe11"
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
