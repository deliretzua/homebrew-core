require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.23.tgz"
  sha256 "30ca48903797ae92920511579a7ff73cd6490721c5317124410edbcd12f0b971"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4032104a3689f2fdf2efd7685a7594408d688310872e03b3d46efd31b8e798cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4032104a3689f2fdf2efd7685a7594408d688310872e03b3d46efd31b8e798cb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a26d3a69da01c7f26625437dc5a484047cad5bd9a09aa56193830fce5b648c87"
    sha256 cellar: :any_skip_relocation, ventura:        "33bf61fb8eb8cc827aa3690485781e360c9301f65e79ac7c9f55bfeb70e20b08"
    sha256 cellar: :any_skip_relocation, monterey:       "33bf61fb8eb8cc827aa3690485781e360c9301f65e79ac7c9f55bfeb70e20b08"
    sha256 cellar: :any_skip_relocation, big_sur:        "33bf61fb8eb8cc827aa3690485781e360c9301f65e79ac7c9f55bfeb70e20b08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a26d3a69da01c7f26625437dc5a484047cad5bd9a09aa56193830fce5b648c87"
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
