require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.47.6.tgz"
  sha256 "c6b37722951c1454bf1f89d511cd43766f049e1279b2104c30136d8be0ea72f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9aea9a4c73bcfbb1cd6ebafce56ac13ca4014f894d7983acc75a342b1c93e79d"
    sha256 cellar: :any,                 arm64_monterey: "1b22028a5763f692a48ae16fafdc2ab1f685e70cfdb7b22c33975b621d8511d7"
    sha256 cellar: :any,                 arm64_big_sur:  "ac174d3d77fb92d7f7f23660c0723abcdb7b0f23d76a8c1d09698447da95ba7d"
    sha256 cellar: :any,                 ventura:        "10851ff0f006d59436ceac0a20697e55e1b33e2fdb035dc66a01f6865ea1243f"
    sha256 cellar: :any,                 monterey:       "10851ff0f006d59436ceac0a20697e55e1b33e2fdb035dc66a01f6865ea1243f"
    sha256 cellar: :any,                 big_sur:        "10851ff0f006d59436ceac0a20697e55e1b33e2fdb035dc66a01f6865ea1243f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fac2a3d09c7bc21edf0b81ed814d1242e3375c202646115f229759a4a374837"
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
