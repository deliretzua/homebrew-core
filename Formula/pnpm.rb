class Pnpm < Formula
  require "language/node"

  desc "📦🚀 Fast, disk space efficient package manager"
  homepage "https://pnpm.io/"
  url "https://registry.npmjs.org/pnpm/-/pnpm-6.8.0.tgz"
  sha256 "d909b8b81fa4d348330d7fe9d710394edfebc084a38a29c90a4b4d61bef5d0a3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "32b8b35e8f38215ff413d6a2696894de5817e13ae8a04add992cbc150d518bd6"
    sha256 cellar: :any_skip_relocation, big_sur:       "7b1ef185bee045b7633650504e3b5ae52c2affbe0a71a601267e8cd3b209eba7"
    sha256 cellar: :any_skip_relocation, catalina:      "7b1ef185bee045b7633650504e3b5ae52c2affbe0a71a601267e8cd3b209eba7"
    sha256 cellar: :any_skip_relocation, mojave:        "7b1ef185bee045b7633650504e3b5ae52c2affbe0a71a601267e8cd3b209eba7"
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
