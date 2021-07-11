class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.10.0.tgz"
  sha256 "a2b19cebe4bd74936fa17e6f1275effd50e13447ea32ea9c7964798d370a8e04"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "bd2943fa3cd5fd7c7da0ef39da62924ea0a3b09432d572102aa2c6b151d6b720"
    sha256 cellar: :any_skip_relocation, big_sur:       "069e72dd71f53aa297e88bad29571f74253ffb4afc2febc728bcefcacbecf548"
    sha256 cellar: :any_skip_relocation, catalina:      "069e72dd71f53aa297e88bad29571f74253ffb4afc2febc728bcefcacbecf548"
    sha256 cellar: :any_skip_relocation, mojave:        "069e72dd71f53aa297e88bad29571f74253ffb4afc2febc728bcefcacbecf548"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "d7add6bd0678a8b0ea41b5d5a057158ff715ca20238f0a585fff64edaa3048f3"
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
