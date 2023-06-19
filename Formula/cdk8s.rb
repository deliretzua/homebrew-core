require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.65.tgz"
  sha256 "d26d66e1b665fa132d8fdefb19d18d45a0b4ac4c09fb691ebedcd0b7050212e0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f4420103fb4ee118f6e3699b752bba3eb6e509f3b2b69093c723051373b77555"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f4420103fb4ee118f6e3699b752bba3eb6e509f3b2b69093c723051373b77555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4420103fb4ee118f6e3699b752bba3eb6e509f3b2b69093c723051373b77555"
    sha256 cellar: :any_skip_relocation, ventura:        "a4e6e869297907b3294fd1384a4bcf2ecfdcf6fa9da68c3bea956ee9d06b3c04"
    sha256 cellar: :any_skip_relocation, monterey:       "a4e6e869297907b3294fd1384a4bcf2ecfdcf6fa9da68c3bea956ee9d06b3c04"
    sha256 cellar: :any_skip_relocation, big_sur:        "a4e6e869297907b3294fd1384a4bcf2ecfdcf6fa9da68c3bea956ee9d06b3c04"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f4420103fb4ee118f6e3699b752bba3eb6e509f3b2b69093c723051373b77555"
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
