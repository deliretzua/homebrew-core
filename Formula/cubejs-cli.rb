require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.27.tgz"
  sha256 "81a379ea12ce99e6438f3ddc57a885d4450816c1ffc63de7007d5eb92be2f29d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a976e9b83c5134c20b4915bbab041d2869b092f4ecd379472c61048ad51a62e"
    sha256 cellar: :any_skip_relocation, big_sur:       "a6991e671ea49dd6855e267642c3f8975b66d0fdd5ddf665b3125c1d10d227fb"
    sha256 cellar: :any_skip_relocation, catalina:      "a6991e671ea49dd6855e267642c3f8975b66d0fdd5ddf665b3125c1d10d227fb"
    sha256 cellar: :any_skip_relocation, mojave:        "a6991e671ea49dd6855e267642c3f8975b66d0fdd5ddf665b3125c1d10d227fb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
