require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.24.tgz"
  sha256 "6688470af5e1abb618d2c64bcfa3665ed860ca31affcebba773d6e87c18a5b48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9e005e314717836ca0ffc00f771fe2c024d92a6d231de86952eaa56d534e169c"
    sha256 cellar: :any_skip_relocation, big_sur:       "39300f5e3491d608aec76878c92a33490586ec22ae2c23e63a4aa92ad3c8fb96"
    sha256 cellar: :any_skip_relocation, catalina:      "39300f5e3491d608aec76878c92a33490586ec22ae2c23e63a4aa92ad3c8fb96"
    sha256 cellar: :any_skip_relocation, mojave:        "39300f5e3491d608aec76878c92a33490586ec22ae2c23e63a4aa92ad3c8fb96"
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
