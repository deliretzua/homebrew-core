require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.47.tgz"
  sha256 "a77fc26609197ab7d4b3b7ee152e1bdb7ab3b4efaf45abc185ef44156997cf51"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c5a48f9326a59f84349611cde373b8c6277f052a9695e4f1fb0b198902e6ad11"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c5a48f9326a59f84349611cde373b8c6277f052a9695e4f1fb0b198902e6ad11"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5a48f9326a59f84349611cde373b8c6277f052a9695e4f1fb0b198902e6ad11"
    sha256 cellar: :any_skip_relocation, ventura:        "4e9cab317835897e315a6cdc8f9b51327b8d6aef4be295384dbc0328495f00b9"
    sha256 cellar: :any_skip_relocation, monterey:       "4e9cab317835897e315a6cdc8f9b51327b8d6aef4be295384dbc0328495f00b9"
    sha256 cellar: :any_skip_relocation, big_sur:        "4e9cab317835897e315a6cdc8f9b51327b8d6aef4be295384dbc0328495f00b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5a48f9326a59f84349611cde373b8c6277f052a9695e4f1fb0b198902e6ad11"
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
