require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.46.tgz"
  sha256 "0f09535fc500b417c844481b5c96849d0f1de43869ebfc0738e38042ccaa49d0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "99e2f7e3d07083d352671a61f889d1c415a161e7607893a736fd650847b6dd56"
    sha256 cellar: :any_skip_relocation, big_sur:       "24653ced8e3d1713d5cb402da6a2a00847d74018bfae21417f20766f9853d5f7"
    sha256 cellar: :any_skip_relocation, catalina:      "24653ced8e3d1713d5cb402da6a2a00847d74018bfae21417f20766f9853d5f7"
    sha256 cellar: :any_skip_relocation, mojave:        "24653ced8e3d1713d5cb402da6a2a00847d74018bfae21417f20766f9853d5f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "99e2f7e3d07083d352671a61f889d1c415a161e7607893a736fd650847b6dd56"
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
