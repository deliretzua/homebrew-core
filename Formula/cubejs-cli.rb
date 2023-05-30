require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.33.19.tgz"
  sha256 "05d0798f2bf3338a4b1f7542891ff911d5c073fa93c069743de7abb5d3147eb8"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "239f9e13e4c1b9b0321db7f1275aee5b876acda8b7a22984a00264f7238b4df8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "239f9e13e4c1b9b0321db7f1275aee5b876acda8b7a22984a00264f7238b4df8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "239f9e13e4c1b9b0321db7f1275aee5b876acda8b7a22984a00264f7238b4df8"
    sha256 cellar: :any_skip_relocation, ventura:        "3738c5cbc90ffcfe518be0bcbea3535dfea273ba1b1632b29cf65e541a5b8fc4"
    sha256 cellar: :any_skip_relocation, monterey:       "3738c5cbc90ffcfe518be0bcbea3535dfea273ba1b1632b29cf65e541a5b8fc4"
    sha256 cellar: :any_skip_relocation, big_sur:        "3738c5cbc90ffcfe518be0bcbea3535dfea273ba1b1632b29cf65e541a5b8fc4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "239f9e13e4c1b9b0321db7f1275aee5b876acda8b7a22984a00264f7238b4df8"
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
