require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.1.3.tgz"
  sha256 "53360d7d3a719729d14471ed57c6b07136e5d4c8777d370be0d10be77ce2d817"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a6e7e07a92978324357b15eb4ad11ab62b87989355b675c9a85c940c4da3644"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a6e7e07a92978324357b15eb4ad11ab62b87989355b675c9a85c940c4da3644"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a6e7e07a92978324357b15eb4ad11ab62b87989355b675c9a85c940c4da3644"
    sha256 cellar: :any_skip_relocation, ventura:        "6b83fb9bcdc03e1bcdcafbaf9559c9a3731146498c44a00e150bf9174d01ddc0"
    sha256 cellar: :any_skip_relocation, monterey:       "6b83fb9bcdc03e1bcdcafbaf9559c9a3731146498c44a00e150bf9174d01ddc0"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b83fb9bcdc03e1bcdcafbaf9559c9a3731146498c44a00e150bf9174d01ddc0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a6e7e07a92978324357b15eb4ad11ab62b87989355b675c9a85c940c4da3644"
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
