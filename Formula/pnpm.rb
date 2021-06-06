class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.js.org"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.7.2.tgz"
  sha256 "c897d217fa85b35cb49d0d7cd734335428289c75b2f1febbc1af3337e6829751"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "65b1a37d705666048bb964ee9bcad28494d897ef5880cb6e15568b083162690d"
    sha256 cellar: :any_skip_relocation, big_sur:       "434314a9f2b0f37da47e658f81daca5f173bf6aad2f758dbd2cdab4b9c200b66"
    sha256 cellar: :any_skip_relocation, catalina:      "434314a9f2b0f37da47e658f81daca5f173bf6aad2f758dbd2cdab4b9c200b66"
    sha256 cellar: :any_skip_relocation, mojave:        "434314a9f2b0f37da47e658f81daca5f173bf6aad2f758dbd2cdab4b9c200b66"
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
