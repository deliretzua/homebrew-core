require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.42.tgz"
  sha256 "efcd744d77f22004aee99c5f6ee0a37c98e2ef5d2704454606e709e008b84b9a"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "112b8d2e3cfd209c4c860731503f5826762ebf7cd7c6fbc9db9cf6426d5f9517"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "112b8d2e3cfd209c4c860731503f5826762ebf7cd7c6fbc9db9cf6426d5f9517"
    sha256 cellar: :any_skip_relocation, monterey:       "358342f8c4335bbeddc7ea54b2c1730df570658f0cad0229dcc104dfcacde13c"
    sha256 cellar: :any_skip_relocation, big_sur:        "358342f8c4335bbeddc7ea54b2c1730df570658f0cad0229dcc104dfcacde13c"
    sha256 cellar: :any_skip_relocation, catalina:       "358342f8c4335bbeddc7ea54b2c1730df570658f0cad0229dcc104dfcacde13c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "112b8d2e3cfd209c4c860731503f5826762ebf7cd7c6fbc9db9cf6426d5f9517"
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
