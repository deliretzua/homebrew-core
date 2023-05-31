require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.20.tgz"
  sha256 "733cba21fbee5823dca6f11966c3dc545769ebe28d7b4793d57e50043ae829c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "381f02e188a90c164e059ecad607e816e0d2f503dee80c62965c9cab09bb3354"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "381f02e188a90c164e059ecad607e816e0d2f503dee80c62965c9cab09bb3354"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "381f02e188a90c164e059ecad607e816e0d2f503dee80c62965c9cab09bb3354"
    sha256 cellar: :any_skip_relocation, ventura:        "a9f9308862f6f79285e4af09095b6a9b94f48c61eee53e12540bc56663413d55"
    sha256 cellar: :any_skip_relocation, monterey:       "a9f9308862f6f79285e4af09095b6a9b94f48c61eee53e12540bc56663413d55"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9f9308862f6f79285e4af09095b6a9b94f48c61eee53e12540bc56663413d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "381f02e188a90c164e059ecad607e816e0d2f503dee80c62965c9cab09bb3354"
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
