require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.6.tgz"
  sha256 "f8f5c2ca613bfa186fd3987c8c0a726e600d840ef1b04d12358d1146a52eb820"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "130c00b0bedae73cbefbed2aaee55d2032d982d5f0b5936f73431899eff1060a"
    sha256 cellar: :any_skip_relocation, big_sur:       "18becc7c3b6150987acdb5b48224045e20eebd06773906768d91d7fe2085edad"
    sha256 cellar: :any_skip_relocation, catalina:      "18becc7c3b6150987acdb5b48224045e20eebd06773906768d91d7fe2085edad"
    sha256 cellar: :any_skip_relocation, mojave:        "18becc7c3b6150987acdb5b48224045e20eebd06773906768d91d7fe2085edad"
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
