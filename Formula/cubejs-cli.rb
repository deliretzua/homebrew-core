require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.39.tgz"
  sha256 "966530eecc3fd9cb9f55b1b9660176c5220d8866f4ef7e1696904a3e68c2073e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "c08e3f658d3d839fe27e6bd5215aa38903695b9d2bc83a8709021d2ecab0e8c3"
    sha256 cellar: :any, arm64_monterey: "c08e3f658d3d839fe27e6bd5215aa38903695b9d2bc83a8709021d2ecab0e8c3"
    sha256 cellar: :any, arm64_big_sur:  "c08e3f658d3d839fe27e6bd5215aa38903695b9d2bc83a8709021d2ecab0e8c3"
    sha256 cellar: :any, ventura:        "85f8ff17d4e4ad1483ed3c6e83e4a84ad2189ea226959e8b0094b39cd933b58f"
    sha256 cellar: :any, monterey:       "85f8ff17d4e4ad1483ed3c6e83e4a84ad2189ea226959e8b0094b39cd933b58f"
    sha256 cellar: :any, big_sur:        "85f8ff17d4e4ad1483ed3c6e83e4a84ad2189ea226959e8b0094b39cd933b58f"
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
