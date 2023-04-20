require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.39.2.tgz"
  sha256 "96b1191287d68040517a7aebd9af170c1bb649f96005312b374c102230e34218"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8c1644898baa12ec5080ee13eafc8b735761a6de61b5c308986bf1112c1b3a1c"
    sha256 cellar: :any,                 arm64_monterey: "8c1644898baa12ec5080ee13eafc8b735761a6de61b5c308986bf1112c1b3a1c"
    sha256 cellar: :any,                 arm64_big_sur:  "8c1644898baa12ec5080ee13eafc8b735761a6de61b5c308986bf1112c1b3a1c"
    sha256 cellar: :any,                 ventura:        "3a48f74306c633279bf787b07ccaf996b1da3ce96598aab589f6093dbac8e3a0"
    sha256 cellar: :any,                 monterey:       "3a48f74306c633279bf787b07ccaf996b1da3ce96598aab589f6093dbac8e3a0"
    sha256 cellar: :any,                 big_sur:        "3a48f74306c633279bf787b07ccaf996b1da3ce96598aab589f6093dbac8e3a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6107e366db2647744837fe59e570e45c65e079a2b4e540318a9a28f97913acd4"
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
