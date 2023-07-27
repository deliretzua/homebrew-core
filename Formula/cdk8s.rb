require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.10.0.tgz"
  sha256 "5092e8aa94f89386799af4507fa1c1d3c8c57b19584d10fd1005da29b8b9fe46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4de5ccb0225962b19603b2a1f5b185ee2a8308a22f1b08085444eb0a36f13e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4de5ccb0225962b19603b2a1f5b185ee2a8308a22f1b08085444eb0a36f13e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4de5ccb0225962b19603b2a1f5b185ee2a8308a22f1b08085444eb0a36f13e6"
    sha256 cellar: :any_skip_relocation, ventura:        "6735cc1481e81fcc20c95482e974c5be773ed1d1e371952be0ca5325c7c91ced"
    sha256 cellar: :any_skip_relocation, monterey:       "6735cc1481e81fcc20c95482e974c5be773ed1d1e371952be0ca5325c7c91ced"
    sha256 cellar: :any_skip_relocation, big_sur:        "6735cc1481e81fcc20c95482e974c5be773ed1d1e371952be0ca5325c7c91ced"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abdf998a28f080deb9b8f44ca1c62bedb2bf57107c55fb19e71256b4ea7fd5cb"
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
