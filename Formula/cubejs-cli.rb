require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.33.tgz"
  sha256 "2d79432e0b0b29af47c3b8962612c543ad156441702b4fad5b54fb595d1d8953"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a9a6d4a45948c3049c5b2a39c48dafcc23dc5e126e1cf403bd8ed0c5e6940ab8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a9a6d4a45948c3049c5b2a39c48dafcc23dc5e126e1cf403bd8ed0c5e6940ab8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9a6d4a45948c3049c5b2a39c48dafcc23dc5e126e1cf403bd8ed0c5e6940ab8"
    sha256 cellar: :any_skip_relocation, ventura:        "21e1bae4b3fdb490dbd5a4ab022f36103e8f4ebc5b9afab49d7301481765e4b4"
    sha256 cellar: :any_skip_relocation, monterey:       "21e1bae4b3fdb490dbd5a4ab022f36103e8f4ebc5b9afab49d7301481765e4b4"
    sha256 cellar: :any_skip_relocation, big_sur:        "21e1bae4b3fdb490dbd5a4ab022f36103e8f4ebc5b9afab49d7301481765e4b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9a6d4a45948c3049c5b2a39c48dafcc23dc5e126e1cf403bd8ed0c5e6940ab8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
