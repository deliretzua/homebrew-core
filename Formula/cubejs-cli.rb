require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.37.tgz"
  sha256 "26922d2b558ff783119cfbae2de5bbfffd4019b09324ca749347997aac6435e1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9afe58857cc26facec537dbfa450c51755ee13e7fbac405dad62a290f84654e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9afe58857cc26facec537dbfa450c51755ee13e7fbac405dad62a290f84654e2"
    sha256 cellar: :any_skip_relocation, monterey:       "79f80556b4854ca1b1bd62f3014fb91295dbc79bdc3b1c927aabe4b48bf08f06"
    sha256 cellar: :any_skip_relocation, big_sur:        "79f80556b4854ca1b1bd62f3014fb91295dbc79bdc3b1c927aabe4b48bf08f06"
    sha256 cellar: :any_skip_relocation, catalina:       "79f80556b4854ca1b1bd62f3014fb91295dbc79bdc3b1c927aabe4b48bf08f06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9afe58857cc26facec537dbfa450c51755ee13e7fbac405dad62a290f84654e2"
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
