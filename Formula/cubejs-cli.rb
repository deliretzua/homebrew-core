require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.68.tgz"
  sha256 "ab808e53095c6826de72eb08f4fe6717b7659eeda925da320a2338433090dd09"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec2fd4777c93b7e7e2652ffeda5cbb90609a0e085bd91d5fdd4548e26acbf63c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ec2fd4777c93b7e7e2652ffeda5cbb90609a0e085bd91d5fdd4548e26acbf63c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ec2fd4777c93b7e7e2652ffeda5cbb90609a0e085bd91d5fdd4548e26acbf63c"
    sha256 cellar: :any_skip_relocation, ventura:        "98ac569cb2de4a3ec7cf159786bdeba57475d4528eeb53e58120ebaf04050615"
    sha256 cellar: :any_skip_relocation, monterey:       "98ac569cb2de4a3ec7cf159786bdeba57475d4528eeb53e58120ebaf04050615"
    sha256 cellar: :any_skip_relocation, big_sur:        "98ac569cb2de4a3ec7cf159786bdeba57475d4528eeb53e58120ebaf04050615"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ec2fd4777c93b7e7e2652ffeda5cbb90609a0e085bd91d5fdd4548e26acbf63c"
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
