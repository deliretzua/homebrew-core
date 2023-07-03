require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.88.tgz"
  sha256 "3cbfcdd581f1c3b4c1d50f6d1f6eb445ff305d1d90891af24b0378275309991c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b4d83b1f1f2c2453e3e7a603f5678738681498cb9f61ecf22b552214eed0e412"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4d83b1f1f2c2453e3e7a603f5678738681498cb9f61ecf22b552214eed0e412"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22fcee26f5f5f816426462f0f602efd2b3113da345f04c6dbd5a70e073b5b610"
    sha256 cellar: :any_skip_relocation, ventura:        "8f0bb79a1302a73fb2a2727d103cfb71315221653a12fc749a0f0b503f3cddfb"
    sha256 cellar: :any_skip_relocation, monterey:       "8f0bb79a1302a73fb2a2727d103cfb71315221653a12fc749a0f0b503f3cddfb"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f0bb79a1302a73fb2a2727d103cfb71315221653a12fc749a0f0b503f3cddfb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "22fcee26f5f5f816426462f0f602efd2b3113da345f04c6dbd5a70e073b5b610"
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
