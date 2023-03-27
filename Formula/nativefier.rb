require "language/node"

class Nativefier < Formula
  desc "Wrap web apps natively"
  homepage "https://github.com/nativefier/nativefier"
  url "https://registry.npmjs.org/nativefier/-/nativefier-50.1.1.tgz"
  sha256 "11587e877bad9a6859bb14268d56a60548d44e550f0d5da6d8535d9051957207"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "25dd5155530dfc4d39782c7ffdc8322637c2f06b4c8881c3deca81d4ad2e034e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25dd5155530dfc4d39782c7ffdc8322637c2f06b4c8881c3deca81d4ad2e034e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "25dd5155530dfc4d39782c7ffdc8322637c2f06b4c8881c3deca81d4ad2e034e"
    sha256 cellar: :any_skip_relocation, ventura:        "5239d3c85d0d4798e7f271b639927335536c0e7ffde49dd33c06e4e8c092eb14"
    sha256 cellar: :any_skip_relocation, monterey:       "5239d3c85d0d4798e7f271b639927335536c0e7ffde49dd33c06e4e8c092eb14"
    sha256 cellar: :any_skip_relocation, big_sur:        "5239d3c85d0d4798e7f271b639927335536c0e7ffde49dd33c06e4e8c092eb14"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "25dd5155530dfc4d39782c7ffdc8322637c2f06b4c8881c3deca81d4ad2e034e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nativefier --version")
  end
end
