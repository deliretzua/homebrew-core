require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.32.tgz"
  sha256 "22a29e9fd3d87a9a18bb9dc8d43d0bbdb62f33366bf7d79a3f13cddf21b1f8cd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "54011e977883a2dc86af98c8457093b45e915c2f0ec0acae3a8832843373ba29"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54011e977883a2dc86af98c8457093b45e915c2f0ec0acae3a8832843373ba29"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54011e977883a2dc86af98c8457093b45e915c2f0ec0acae3a8832843373ba29"
    sha256 cellar: :any_skip_relocation, ventura:        "ec203a6e1e9f39a8dbba8710d5ce37bbb0ace4c533eebbd5d1edd285ecfaa229"
    sha256 cellar: :any_skip_relocation, monterey:       "ec203a6e1e9f39a8dbba8710d5ce37bbb0ace4c533eebbd5d1edd285ecfaa229"
    sha256 cellar: :any_skip_relocation, big_sur:        "ec203a6e1e9f39a8dbba8710d5ce37bbb0ace4c533eebbd5d1edd285ecfaa229"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54011e977883a2dc86af98c8457093b45e915c2f0ec0acae3a8832843373ba29"
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
