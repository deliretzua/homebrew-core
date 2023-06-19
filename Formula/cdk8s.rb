require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.64.tgz"
  sha256 "b96d75fc2f3819fabbf87f6c58a29eda913b66a174ed856e1c0679380e868ee0"
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
