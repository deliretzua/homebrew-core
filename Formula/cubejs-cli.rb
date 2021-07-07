require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.47.tgz"
  sha256 "c47e7212cf37e9a74ad72afb9e842ef5004d6fda67f25b4a4d7ee6d8d55c0c6c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6fe75dd3f2d5020f00ae2cfec9bb269b78412a0597b73e6c40dbe54efc85e824"
    sha256 cellar: :any_skip_relocation, big_sur:       "f492fb3c489635440d884bcd57ae5df9c9e9e632c53508c140fe336a6c9857f0"
    sha256 cellar: :any_skip_relocation, catalina:      "f492fb3c489635440d884bcd57ae5df9c9e9e632c53508c140fe336a6c9857f0"
    sha256 cellar: :any_skip_relocation, mojave:        "f492fb3c489635440d884bcd57ae5df9c9e9e632c53508c140fe336a6c9857f0"
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
