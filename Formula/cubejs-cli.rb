require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.65.tgz"
  sha256 "448b2c8b5e3ef9f9f7368727b5e3bdc87ff9ac978f062a13a7ddf62e7a3bb9eb"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "15f1c2e280c5e22786fe72f9d98f73b1a74ffa053c5b194c160e0f01fb2aa7dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "15f1c2e280c5e22786fe72f9d98f73b1a74ffa053c5b194c160e0f01fb2aa7dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "15f1c2e280c5e22786fe72f9d98f73b1a74ffa053c5b194c160e0f01fb2aa7dc"
    sha256 cellar: :any_skip_relocation, ventura:        "668af0f523cdf0585892ca8625a21ed8b42842c9bccfe7ab78734e5be0634fad"
    sha256 cellar: :any_skip_relocation, monterey:       "668af0f523cdf0585892ca8625a21ed8b42842c9bccfe7ab78734e5be0634fad"
    sha256 cellar: :any_skip_relocation, big_sur:        "668af0f523cdf0585892ca8625a21ed8b42842c9bccfe7ab78734e5be0634fad"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15f1c2e280c5e22786fe72f9d98f73b1a74ffa053c5b194c160e0f01fb2aa7dc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
