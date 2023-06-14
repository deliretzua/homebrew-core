require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.59.tgz"
  sha256 "cac2d63a028dcfc44dfd73604729901d4873ceb9067b6e5cea83b3024fc38ee2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f918b92cdfc2210b9948f61dbda7dc229a6d1bdcfc646f96695ac554f8d627f5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f918b92cdfc2210b9948f61dbda7dc229a6d1bdcfc646f96695ac554f8d627f5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f918b92cdfc2210b9948f61dbda7dc229a6d1bdcfc646f96695ac554f8d627f5"
    sha256 cellar: :any_skip_relocation, ventura:        "09762ca330de7db728926f0b52bd542367202f9a4ab23eac876e030076219f58"
    sha256 cellar: :any_skip_relocation, monterey:       "09762ca330de7db728926f0b52bd542367202f9a4ab23eac876e030076219f58"
    sha256 cellar: :any_skip_relocation, big_sur:        "09762ca330de7db728926f0b52bd542367202f9a4ab23eac876e030076219f58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f918b92cdfc2210b9948f61dbda7dc229a6d1bdcfc646f96695ac554f8d627f5"
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
