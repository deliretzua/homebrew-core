require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.33.tgz"
  sha256 "d8938df9600087f9fb72cf79b14f03af037b4e007d7d5f04be2ecc0bc5f85d69"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dd02c2d5124ad6f328df1d131220e1277a86447b3e76d203bfc2c6920807d69"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dd02c2d5124ad6f328df1d131220e1277a86447b3e76d203bfc2c6920807d69"
    sha256 cellar: :any_skip_relocation, monterey:       "ea86a8a48e5c15423dd5bd3e7c0fb569bbb5e67fb79b9b19394f0ae114fae645"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea86a8a48e5c15423dd5bd3e7c0fb569bbb5e67fb79b9b19394f0ae114fae645"
    sha256 cellar: :any_skip_relocation, catalina:       "ea86a8a48e5c15423dd5bd3e7c0fb569bbb5e67fb79b9b19394f0ae114fae645"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dd02c2d5124ad6f328df1d131220e1277a86447b3e76d203bfc2c6920807d69"
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
