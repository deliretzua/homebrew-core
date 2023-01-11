require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.38.tgz"
  sha256 "43a0ec7d51f3791467eb3abdb5d40d4b8cef64f34b2e7bde16663aa3d1a2372e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b3d4b48b3626b0daca76c76a5499658234ebf4bce2c76cc8014b3514c27ffb1a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b3d4b48b3626b0daca76c76a5499658234ebf4bce2c76cc8014b3514c27ffb1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b3d4b48b3626b0daca76c76a5499658234ebf4bce2c76cc8014b3514c27ffb1a"
    sha256 cellar: :any_skip_relocation, ventura:        "e18d6ba80c7e9bfa5f819d025b6b1648a3c0eff7cb256c0da9a269f56b12afa8"
    sha256 cellar: :any_skip_relocation, monterey:       "e18d6ba80c7e9bfa5f819d025b6b1648a3c0eff7cb256c0da9a269f56b12afa8"
    sha256 cellar: :any_skip_relocation, big_sur:        "e18d6ba80c7e9bfa5f819d025b6b1648a3c0eff7cb256c0da9a269f56b12afa8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b3d4b48b3626b0daca76c76a5499658234ebf4bce2c76cc8014b3514c27ffb1a"
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
