require "language/node"

class Renovate < Formula
  desc "Automated dependency updates. Flexible so you don't need to be"
  homepage "https://github.com/renovatebot/renovate"
  url "https://registry.npmjs.org/renovate/-/renovate-35.31.4.tgz"
  sha256 "d09cbc6b6ee159f0f4c02ac401d3b4ba35e8af48688a1ad31f299508bad79588"
  license "AGPL-3.0-only"

  bottle do
    sha256                               arm64_ventura:  "028c77678ee726ddbdf047a612cb0c70ca1f97dbd13e91400a57e45a0fee9fed"
    sha256                               arm64_monterey: "1be20fda499dbad73df4cf21e0eb3415ddefad596fce264257246387008e0931"
    sha256                               arm64_big_sur:  "f60f015cfa3130dd61c2a5041bf5122f597709c73cf03193b43973daa00b149c"
    sha256 cellar: :any_skip_relocation, ventura:        "f9b04eb97eae8bfb41ef613b9360469ca40552a5bd0214543de1b8b795dc9b32"
    sha256 cellar: :any_skip_relocation, monterey:       "ddc37c02c3a0c1d1ca24bc2ab2e709f3712cca50fa6b218931d4c199c6059e67"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a2e7347810fd507e5264da11b77bbb14db174e18c0c4ba0d084126052cca90e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0e51510e57d8233fec0356273edf08914b2920ab16d86e240634920e5639e010"
  end

  depends_on "node"

  uses_from_macos "git", since: :monterey

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "FATAL: You must configure a GitHub token", shell_output("#{bin}/renovate 2>&1", 1)
  end
end
