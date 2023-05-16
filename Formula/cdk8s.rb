require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.34.tgz"
  sha256 "bc470750a47102d85588cc0203b8f7390d595cb4c617553fb17bd50ff1bb5749"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eff89735e9f11925b623e1b0f5e68278ad6a347d4d5d375a4c565d5fa979a6c1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "eff89735e9f11925b623e1b0f5e68278ad6a347d4d5d375a4c565d5fa979a6c1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "eff89735e9f11925b623e1b0f5e68278ad6a347d4d5d375a4c565d5fa979a6c1"
    sha256 cellar: :any_skip_relocation, ventura:        "a29f468cda94e449339352f2527a4393bb45a37f18a21ccc268c0eab617cb8bd"
    sha256 cellar: :any_skip_relocation, monterey:       "a29f468cda94e449339352f2527a4393bb45a37f18a21ccc268c0eab617cb8bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "a29f468cda94e449339352f2527a4393bb45a37f18a21ccc268c0eab617cb8bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eff89735e9f11925b623e1b0f5e68278ad6a347d4d5d375a4c565d5fa979a6c1"
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
