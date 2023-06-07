require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.25.tgz"
  sha256 "dcdbeb3eab1aaa4e40454f1053185045ca56be7f4cf28533794f65c6fa92c040"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50ecb3c59668696788afddd989cf31edfe102461fecc4393e79b5d0a9f8eca1e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50ecb3c59668696788afddd989cf31edfe102461fecc4393e79b5d0a9f8eca1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50ecb3c59668696788afddd989cf31edfe102461fecc4393e79b5d0a9f8eca1e"
    sha256 cellar: :any_skip_relocation, ventura:        "d0bd721cff382291b6df789b7f1e8cb015dae3f242a9f051773ca53b4b517941"
    sha256 cellar: :any_skip_relocation, monterey:       "d0bd721cff382291b6df789b7f1e8cb015dae3f242a9f051773ca53b4b517941"
    sha256 cellar: :any_skip_relocation, big_sur:        "d0bd721cff382291b6df789b7f1e8cb015dae3f242a9f051773ca53b4b517941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50ecb3c59668696788afddd989cf31edfe102461fecc4393e79b5d0a9f8eca1e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/model/cubes/orders.yml", :exist?
  end
end
