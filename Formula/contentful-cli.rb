require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.27.tgz"
  sha256 "02c7092d700c963cc8744c558d3564b0241406239e1f81e3d993af3c8ca35e50"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9ff4143e014565e8edacbab2f88e8266cb60d6c82c72046a578f1ec2b12466a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9ff4143e014565e8edacbab2f88e8266cb60d6c82c72046a578f1ec2b12466a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9ff4143e014565e8edacbab2f88e8266cb60d6c82c72046a578f1ec2b12466a"
    sha256 cellar: :any_skip_relocation, ventura:        "34b3df65e09cd248c0e89bfa17de19c96db8cd8255ba67b8e86c0f2a3c37cfd2"
    sha256 cellar: :any_skip_relocation, monterey:       "34b3df65e09cd248c0e89bfa17de19c96db8cd8255ba67b8e86c0f2a3c37cfd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "34b3df65e09cd248c0e89bfa17de19c96db8cd8255ba67b8e86c0f2a3c37cfd2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d9ff4143e014565e8edacbab2f88e8266cb60d6c82c72046a578f1ec2b12466a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
