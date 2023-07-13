require "language/node"

class Cdk8s < Formula
  desc "Define k8s native apps and abstractions using object-oriented programming"
  homepage "https://cdk8s.io/"
  url "https://registry.npmjs.org/cdk8s-cli/-/cdk8s-cli-2.2.107.tgz"
  sha256 "4296d426d324ea19058dd034a7087188c81e44aba9d2e9ff546b022b2dab4afe"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e28b9cd1518ebaee113a16078eed67923a1502c125b8a3eea9950a74e99dccf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e28b9cd1518ebaee113a16078eed67923a1502c125b8a3eea9950a74e99dccf2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e28b9cd1518ebaee113a16078eed67923a1502c125b8a3eea9950a74e99dccf2"
    sha256 cellar: :any_skip_relocation, ventura:        "2b6d95c4f590fbd65c4c981240b8e65ecd358f912cfa002f81ca6d72d37fdc51"
    sha256 cellar: :any_skip_relocation, monterey:       "5bc9760ba49370ef2bea539f6f4788db293a4a70a069971c38d53e62d6c2787e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5bc9760ba49370ef2bea539f6f4788db293a4a70a069971c38d53e62d6c2787e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e28b9cd1518ebaee113a16078eed67923a1502c125b8a3eea9950a74e99dccf2"
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
