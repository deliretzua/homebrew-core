require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.13.tgz"
  sha256 "ead48200f61b6cba31f7c91695203983a6aa44a7e5ffde2fbac7a3fb46ecd7a0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ddc020d72e48f6eb5f27e0180c1859c6b16c48c4af0803d5d68f7e3019dfa890"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ddc020d72e48f6eb5f27e0180c1859c6b16c48c4af0803d5d68f7e3019dfa890"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddc020d72e48f6eb5f27e0180c1859c6b16c48c4af0803d5d68f7e3019dfa890"
    sha256 cellar: :any_skip_relocation, monterey:       "5100f45e37d8eee5aecb26b124dda7122673e6ecd883ef820baed65ba6057c21"
    sha256 cellar: :any_skip_relocation, big_sur:        "5100f45e37d8eee5aecb26b124dda7122673e6ecd883ef820baed65ba6057c21"
    sha256 cellar: :any_skip_relocation, catalina:       "5100f45e37d8eee5aecb26b124dda7122673e6ecd883ef820baed65ba6057c21"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ddc020d72e48f6eb5f27e0180c1859c6b16c48c4af0803d5d68f7e3019dfa890"
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
