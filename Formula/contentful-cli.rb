require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.18.0.tgz"
  sha256 "13289eb453e65b7b216a63fd4032a75e9ad904599036739725b4726494f501cf"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7fd37b4a14e9fbb13610b24b08506402ae7b2671ac243a84096a88b0f7e262b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7fd37b4a14e9fbb13610b24b08506402ae7b2671ac243a84096a88b0f7e262b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c7fd37b4a14e9fbb13610b24b08506402ae7b2671ac243a84096a88b0f7e262b"
    sha256 cellar: :any_skip_relocation, ventura:        "6e1f3aab041bba1b4366a72aec459d0b7e25375c8508ef7ed119d681532bf579"
    sha256 cellar: :any_skip_relocation, monterey:       "6e1f3aab041bba1b4366a72aec459d0b7e25375c8508ef7ed119d681532bf579"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e1f3aab041bba1b4366a72aec459d0b7e25375c8508ef7ed119d681532bf579"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c7fd37b4a14e9fbb13610b24b08506402ae7b2671ac243a84096a88b0f7e262b"
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
