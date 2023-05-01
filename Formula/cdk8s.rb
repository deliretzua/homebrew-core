require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.24.tgz"
  sha256 "ed417ab45af2d59fab4687c83541765ab120e9befc8d4d2480e065993af5e8c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0a2565217e49283aa9affcbdf4dcd4ed71965a70b208b60dbcb1791da45148a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0a2565217e49283aa9affcbdf4dcd4ed71965a70b208b60dbcb1791da45148a8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0a2565217e49283aa9affcbdf4dcd4ed71965a70b208b60dbcb1791da45148a8"
    sha256 cellar: :any_skip_relocation, ventura:        "77608cff9899d77cb0af7bdb92a25e8579851c04732ff5b4701fc50f07a883c8"
    sha256 cellar: :any_skip_relocation, monterey:       "77608cff9899d77cb0af7bdb92a25e8579851c04732ff5b4701fc50f07a883c8"
    sha256 cellar: :any_skip_relocation, big_sur:        "77608cff9899d77cb0af7bdb92a25e8579851c04732ff5b4701fc50f07a883c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a2565217e49283aa9affcbdf4dcd4ed71965a70b208b60dbcb1791da45148a8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Cannot initialize a project in a non-empty directory",
      shell_output("#{bin}/cdk8s init python-app 2>&1", 1)
  end
end
