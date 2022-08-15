require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.48.tgz"
  sha256 "23037ad694e64887ac2fe2bd26bc20ed54977bc6739cb20802feacf2265272c3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "327ad11c7dcbce05f875f79bc3284da6b70210e25e64479433db5a358f4b3786"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "327ad11c7dcbce05f875f79bc3284da6b70210e25e64479433db5a358f4b3786"
    sha256 cellar: :any_skip_relocation, monterey:       "558023f52a3e5e49be18547e708c2b80626186e305570e7c979df9de4988366d"
    sha256 cellar: :any_skip_relocation, big_sur:        "558023f52a3e5e49be18547e708c2b80626186e305570e7c979df9de4988366d"
    sha256 cellar: :any_skip_relocation, catalina:       "558023f52a3e5e49be18547e708c2b80626186e305570e7c979df9de4988366d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "327ad11c7dcbce05f875f79bc3284da6b70210e25e64479433db5a358f4b3786"
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
