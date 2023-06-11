require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.57.tgz"
  sha256 "20fbe6138d06fe46041ac6be87b5b4b2ba7306a07439935b832227e0a6199f46"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c260c5542a194d2f3a89faecce28bf7d4d6b4f7be0a4166d96229aca1ba3c6c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c260c5542a194d2f3a89faecce28bf7d4d6b4f7be0a4166d96229aca1ba3c6c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c260c5542a194d2f3a89faecce28bf7d4d6b4f7be0a4166d96229aca1ba3c6c8"
    sha256 cellar: :any_skip_relocation, ventura:        "c602edb1e90a92f5a1ca74a1a6e0542deb02d819a8c4c4cfd02b7f91eeaca830"
    sha256 cellar: :any_skip_relocation, monterey:       "c602edb1e90a92f5a1ca74a1a6e0542deb02d819a8c4c4cfd02b7f91eeaca830"
    sha256 cellar: :any_skip_relocation, big_sur:        "c602edb1e90a92f5a1ca74a1a6e0542deb02d819a8c4c4cfd02b7f91eeaca830"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c260c5542a194d2f3a89faecce28bf7d4d6b4f7be0a4166d96229aca1ba3c6c8"
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
