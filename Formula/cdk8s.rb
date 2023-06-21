require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.69.tgz"
  sha256 "2c235ba08877a4b78201bc4d189dd3d2cac7edd02aebe1ed80366cc9927c58f5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ae45fc09330f1592a5be596ca25061af453251f47972a634089a93947079bfa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ae45fc09330f1592a5be596ca25061af453251f47972a634089a93947079bfa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9473a8942a5f284ccad1575e68b0518258c2b1cd450a30ae2574ee17dae58613"
    sha256 cellar: :any_skip_relocation, ventura:        "d30b37fccb58cb30c0ab006207b5a1146c2dea6f04ed2edff5d83ff084d43f52"
    sha256 cellar: :any_skip_relocation, monterey:       "d30b37fccb58cb30c0ab006207b5a1146c2dea6f04ed2edff5d83ff084d43f52"
    sha256 cellar: :any_skip_relocation, big_sur:        "d30b37fccb58cb30c0ab006207b5a1146c2dea6f04ed2edff5d83ff084d43f52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ae45fc09330f1592a5be596ca25061af453251f47972a634089a93947079bfa"
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
