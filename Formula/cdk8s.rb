require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.22.tgz"
  sha256 "7c7c26a9cab447429ca7d574e9546fe8630f4c267a9a99d064e157a1f6fe20e6"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f47667b1b9217d55657f1a65612586dfb4f06b5d7d1ac86c25e4c800676609e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8f47667b1b9217d55657f1a65612586dfb4f06b5d7d1ac86c25e4c800676609e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8f47667b1b9217d55657f1a65612586dfb4f06b5d7d1ac86c25e4c800676609e"
    sha256 cellar: :any_skip_relocation, ventura:        "bf234b14666782350bbebc7335d6ccff48f9048f3494d55ca2396222a05e34c1"
    sha256 cellar: :any_skip_relocation, monterey:       "bf234b14666782350bbebc7335d6ccff48f9048f3494d55ca2396222a05e34c1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bf234b14666782350bbebc7335d6ccff48f9048f3494d55ca2396222a05e34c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f47667b1b9217d55657f1a65612586dfb4f06b5d7d1ac86c25e4c800676609e"
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
