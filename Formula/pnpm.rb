class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.9.0.tgz"
  sha256 "95dc47a759a92235576da3c8dc55c1b63fcb55e5fcc8ee69989de1e850f48eb8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd254b36ae9567f18c1ee34bb29c574b356f7622a19134deecec688bce192254"
    sha256 cellar: :any_skip_relocation, big_sur:       "1945dbe9a15f3729f0d91eff8410146f235c51f42f3d7ebc4d47931f3f369aeb"
    sha256 cellar: :any_skip_relocation, catalina:      "1945dbe9a15f3729f0d91eff8410146f235c51f42f3d7ebc4d47931f3f369aeb"
    sha256 cellar: :any_skip_relocation, mojave:        "1945dbe9a15f3729f0d91eff8410146f235c51f42f3d7ebc4d47931f3f369aeb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/pnpm", "init", "-y"
    assert_predicate testpath/"package.json", :exist?, "package.json must exist"
  end
end
