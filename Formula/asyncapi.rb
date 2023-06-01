require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.45.8.tgz"
  sha256 "829703a6b23232c0c26cbea489df9f23536ad0f5a389e75336ae6cc047991276"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3d6312da8526229f161c69dbc6fd716c388feffe37ac871dd3ecf77d926bc50d"
    sha256 cellar: :any,                 arm64_monterey: "3d6312da8526229f161c69dbc6fd716c388feffe37ac871dd3ecf77d926bc50d"
    sha256 cellar: :any,                 arm64_big_sur:  "3d6312da8526229f161c69dbc6fd716c388feffe37ac871dd3ecf77d926bc50d"
    sha256 cellar: :any,                 ventura:        "d399cd459b229f8578921687f1de11852878861d6840aad5b288e5e0d3164451"
    sha256 cellar: :any,                 monterey:       "d399cd459b229f8578921687f1de11852878861d6840aad5b288e5e0d3164451"
    sha256 cellar: :any,                 big_sur:        "d399cd459b229f8578921687f1de11852878861d6840aad5b288e5e0d3164451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f6cdbf45834de40a650d16074b35816ae32c4faf700c05ead32bf3d12bfee3f"
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
