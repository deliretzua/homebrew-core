require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.39.1.tgz"
  sha256 "93914e228d6b85e6a6f580874405f03ec1f35039297be9e7d3613678cd611495"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b15fa203e210bc296840a212d2fd950ade78749db31d914ae4248bd9d01c9d9e"
    sha256 cellar: :any,                 arm64_monterey: "b15fa203e210bc296840a212d2fd950ade78749db31d914ae4248bd9d01c9d9e"
    sha256 cellar: :any,                 arm64_big_sur:  "b15fa203e210bc296840a212d2fd950ade78749db31d914ae4248bd9d01c9d9e"
    sha256 cellar: :any,                 ventura:        "60f0d9c148b3882982ccf033def7821adcdad6da0ebf47edefe70c365e8b4e53"
    sha256 cellar: :any,                 monterey:       "60f0d9c148b3882982ccf033def7821adcdad6da0ebf47edefe70c365e8b4e53"
    sha256 cellar: :any,                 big_sur:        "60f0d9c148b3882982ccf033def7821adcdad6da0ebf47edefe70c365e8b4e53"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7f7ee8c055bfa2abc25f62fd0456c867d9f02590b6e1a7330212b220d2c9085"
  end

  depends_on "node"

  def install
    # Call rm -f instead of rimraf, because devDeps aren't present in Homebrew at postpack time
    inreplace "package.json", "rimraf oclif.manifest.json", "rm -f oclif.manifest.json"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Delete native binaries installed by npm, as we dont support `musl` for a `libc` implementation
    node_modules = libexec/"lib/node_modules/@asyncapi/cli/node_modules"
    (node_modules/"@swc/core-linux-x64-musl/swc.linux-x64-musl.node").unlink if OS.linux?

    # Replace universal binaries with their native slices
    deuniversalize_machos
  end

  test do
    system bin/"asyncapi", "new", "--file-name=asyncapi.yml", "--example=default-example.yaml", "--no-tty"
    assert_predicate testpath/"asyncapi.yml", :exist?, "AsyncAPI file was not created"
  end
end
