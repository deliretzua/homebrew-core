require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.42.tgz"
  sha256 "6bf85415073269d2368c1bf75f7468607c0d4f92c752aa67e51d210ad9d8de93"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1275ee38fa5d61378bcd0e4572814ff1424ed5fd3b1d9b060f2dc3670c1ae8e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1275ee38fa5d61378bcd0e4572814ff1424ed5fd3b1d9b060f2dc3670c1ae8e6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1275ee38fa5d61378bcd0e4572814ff1424ed5fd3b1d9b060f2dc3670c1ae8e6"
    sha256 cellar: :any_skip_relocation, ventura:        "65c6833f98144d0c0cda57dfe0d284b6633de6a4ec5c7c84b9dc5172b94232b1"
    sha256 cellar: :any_skip_relocation, monterey:       "65c6833f98144d0c0cda57dfe0d284b6633de6a4ec5c7c84b9dc5172b94232b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "65c6833f98144d0c0cda57dfe0d284b6633de6a4ec5c7c84b9dc5172b94232b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1275ee38fa5d61378bcd0e4572814ff1424ed5fd3b1d9b060f2dc3670c1ae8e6"
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
