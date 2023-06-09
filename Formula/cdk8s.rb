require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.56.tgz"
  sha256 "4020c85abac6718d176a82e408394b25b27e01b9e4f6bfa74827591556db3461"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5dbb60aa2a892a77db38088bf9ceccbbe400ee5c30e22586ec12857a057e28f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f5dbb60aa2a892a77db38088bf9ceccbbe400ee5c30e22586ec12857a057e28f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f5dbb60aa2a892a77db38088bf9ceccbbe400ee5c30e22586ec12857a057e28f"
    sha256 cellar: :any_skip_relocation, ventura:        "d03afaa9d2914f7ee0fd32ed511f9c25bd333e45c14d179a77d1f27e61080098"
    sha256 cellar: :any_skip_relocation, monterey:       "d03afaa9d2914f7ee0fd32ed511f9c25bd333e45c14d179a77d1f27e61080098"
    sha256 cellar: :any_skip_relocation, big_sur:        "d03afaa9d2914f7ee0fd32ed511f9c25bd333e45c14d179a77d1f27e61080098"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5dbb60aa2a892a77db38088bf9ceccbbe400ee5c30e22586ec12857a057e28f"
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
