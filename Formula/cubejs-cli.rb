require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.62.tgz"
  sha256 "b3323c031d5c4637778d7c440fb8cb86fa7b2b60f4b43bc23f4fa41b3c85e4bd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0cb54b4765a36603fc80312942bcbcef24e3945c406d7b50e462ec3cae1ed9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f0cb54b4765a36603fc80312942bcbcef24e3945c406d7b50e462ec3cae1ed9d"
    sha256 cellar: :any_skip_relocation, monterey:       "4d77f40e3c59d2cdde59501f7d1c97cde46409d45a3049a9a977abc3f088971b"
    sha256 cellar: :any_skip_relocation, big_sur:        "4d77f40e3c59d2cdde59501f7d1c97cde46409d45a3049a9a977abc3f088971b"
    sha256 cellar: :any_skip_relocation, catalina:       "4d77f40e3c59d2cdde59501f7d1c97cde46409d45a3049a9a977abc3f088971b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f0cb54b4765a36603fc80312942bcbcef24e3945c406d7b50e462ec3cae1ed9d"
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
