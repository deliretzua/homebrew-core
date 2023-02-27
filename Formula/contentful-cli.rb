require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # 1.19.0 introduced a big code layout change, which is not easy to patch.
  # TODO: re-add version throttling in next bump
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.1.0.tgz"
  sha256 "b851ba2545a43cc7660d819fddbf0902b82d3c8713a8be9c6e3d8266440e7646"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6708f29e2d27130943c9fdca1a20a978d8b4c501b76342ee50eeb15925a33d33"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6708f29e2d27130943c9fdca1a20a978d8b4c501b76342ee50eeb15925a33d33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6708f29e2d27130943c9fdca1a20a978d8b4c501b76342ee50eeb15925a33d33"
    sha256 cellar: :any_skip_relocation, ventura:        "a98ea57e378f33740cd6763c21befbb1054cbabc9050459aea94a0fe94db5d05"
    sha256 cellar: :any_skip_relocation, monterey:       "a98ea57e378f33740cd6763c21befbb1054cbabc9050459aea94a0fe94db5d05"
    sha256 cellar: :any_skip_relocation, big_sur:        "a98ea57e378f33740cd6763c21befbb1054cbabc9050459aea94a0fe94db5d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6708f29e2d27130943c9fdca1a20a978d8b4c501b76342ee50eeb15925a33d33"
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
