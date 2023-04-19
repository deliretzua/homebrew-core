require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.28.tgz"
  sha256 "1488fa555c264f2990ac4330344acaafcf8b55168d6fe3278264de5175044968"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "411bd14828168fe80dc56c1afbfa70855f4d383b172a76192c0e818e49f84cd5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "411bd14828168fe80dc56c1afbfa70855f4d383b172a76192c0e818e49f84cd5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "411bd14828168fe80dc56c1afbfa70855f4d383b172a76192c0e818e49f84cd5"
    sha256 cellar: :any_skip_relocation, ventura:        "34c8a67483acd078ae3c2df785cda35230e19e4ae16bd3c01ba85e0f9239a2c2"
    sha256 cellar: :any_skip_relocation, monterey:       "34c8a67483acd078ae3c2df785cda35230e19e4ae16bd3c01ba85e0f9239a2c2"
    sha256 cellar: :any_skip_relocation, big_sur:        "34c8a67483acd078ae3c2df785cda35230e19e4ae16bd3c01ba85e0f9239a2c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "411bd14828168fe80dc56c1afbfa70855f4d383b172a76192c0e818e49f84cd5"
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
