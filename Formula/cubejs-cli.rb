require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.21.tgz"
  sha256 "db97badec87a48e9b2a55773cfee19d3fe1c1465f990c1531da3a10b38ff9fb5"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "72fecd7b5b38e4328c8add90ff63c8cbf93c9bef5dadd24fa82497214b797b8d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "72fecd7b5b38e4328c8add90ff63c8cbf93c9bef5dadd24fa82497214b797b8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "72fecd7b5b38e4328c8add90ff63c8cbf93c9bef5dadd24fa82497214b797b8d"
    sha256 cellar: :any_skip_relocation, ventura:        "45d033f3a13be05a19009eb2c0c171df1881d4acbfecc1dd7eed45c089d42ba0"
    sha256 cellar: :any_skip_relocation, monterey:       "45d033f3a13be05a19009eb2c0c171df1881d4acbfecc1dd7eed45c089d42ba0"
    sha256 cellar: :any_skip_relocation, big_sur:        "45d033f3a13be05a19009eb2c0c171df1881d4acbfecc1dd7eed45c089d42ba0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72fecd7b5b38e4328c8add90ff63c8cbf93c9bef5dadd24fa82497214b797b8d"
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
