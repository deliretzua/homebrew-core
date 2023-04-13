require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.26.tgz"
  sha256 "1d2606e02cf51bd56cf9d178c87bd7657da57b4b4bb3a6c95b8ec7095faf92c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1b0090ee48494d5bd69ba4d50edd22aee511b68b72b198906e627f24a3ad96c9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1b0090ee48494d5bd69ba4d50edd22aee511b68b72b198906e627f24a3ad96c9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1b0090ee48494d5bd69ba4d50edd22aee511b68b72b198906e627f24a3ad96c9"
    sha256 cellar: :any_skip_relocation, ventura:        "3c9ab70f382ca8339824e1e91ca5e22ecd7d3f83296f98c84dd211536d501d09"
    sha256 cellar: :any_skip_relocation, monterey:       "3c9ab70f382ca8339824e1e91ca5e22ecd7d3f83296f98c84dd211536d501d09"
    sha256 cellar: :any_skip_relocation, big_sur:        "3c9ab70f382ca8339824e1e91ca5e22ecd7d3f83296f98c84dd211536d501d09"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1b0090ee48494d5bd69ba4d50edd22aee511b68b72b198906e627f24a3ad96c9"
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
