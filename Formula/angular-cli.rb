require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.0.4.tgz"
  sha256 "b7aa6a6f5b36b16cbffc819e33aa93a9b960e0f67a0b81f755d5800092b4e461"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ebefb2ae9496e6450df83ba69fae8f31880472e16c91703d637d2718eef1299"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7ebefb2ae9496e6450df83ba69fae8f31880472e16c91703d637d2718eef1299"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7ebefb2ae9496e6450df83ba69fae8f31880472e16c91703d637d2718eef1299"
    sha256 cellar: :any_skip_relocation, ventura:        "6a0e33c561ab837eab209fbdba3e873246c49e6778953202fc0649f633f004d1"
    sha256 cellar: :any_skip_relocation, monterey:       "6a0e33c561ab837eab209fbdba3e873246c49e6778953202fc0649f633f004d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a0e33c561ab837eab209fbdba3e873246c49e6778953202fc0649f633f004d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7ebefb2ae9496e6450df83ba69fae8f31880472e16c91703d637d2718eef1299"
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
