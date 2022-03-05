require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.30.tgz"
  sha256 "90273ee6c29ecf4dd404b3901d97d0e6859db65c25996d53954bd9f9a8fd2211"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d7731eb7bf3bb56d709df05586112fabdcfd232565e9c34173ac0cda1964b401"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d7731eb7bf3bb56d709df05586112fabdcfd232565e9c34173ac0cda1964b401"
    sha256 cellar: :any_skip_relocation, monterey:       "de9b503cd18998941c2b10753fea59ae7cbf48f097f78a81ae120e6eb1e83d0c"
    sha256 cellar: :any_skip_relocation, big_sur:        "de9b503cd18998941c2b10753fea59ae7cbf48f097f78a81ae120e6eb1e83d0c"
    sha256 cellar: :any_skip_relocation, catalina:       "de9b503cd18998941c2b10753fea59ae7cbf48f097f78a81ae120e6eb1e83d0c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d7731eb7bf3bb56d709df05586112fabdcfd232565e9c34173ac0cda1964b401"
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
