require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  # 1.19.0 introduced a big code layout change, which is not easy to patch.
  # TODO: re-add version throttling in next bump
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.0.1.tgz"
  sha256 "2ef5d2cdffee5c17e7c9f6873bf058c2ebba86c1b964924b282aad049dc68ce3"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "366cf89237f634954c361f166eb437da181f12fed6bd666013319c847ea8fcb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ca899101f1b13ea963e79baaefc2a66b69b64ca79cc5d143256b40d10f661ae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74e8ad308a9bf9095fa02c84456534b593711217232c7d48a93ef3dd206e5979"
    sha256 cellar: :any_skip_relocation, ventura:        "1360554d7dc905b99dee29e041c42c307d4eb9eb4881482698b48a5ec407513e"
    sha256 cellar: :any_skip_relocation, monterey:       "0a7c258bed05f1c22ce739882d7fa6dac5bec9821f2ee5bc888bd07199d449d2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8326353b6ccf9c14db507a2f14ebc43481750d604b0bbc2bab2a7c323c08984f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "43b37900586eabb15a69480c8dd344bc40980c44ac0121f8af3d6b2098eac69a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
