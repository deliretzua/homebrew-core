require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.45.8.tgz"
  sha256 "829703a6b23232c0c26cbea489df9f23536ad0f5a389e75336ae6cc047991276"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "9f9475a95ceb6946dcd33f1e3755957c8bda75011daf626c8ca7ac2ca3f80317"
    sha256 cellar: :any,                 arm64_monterey: "9f9475a95ceb6946dcd33f1e3755957c8bda75011daf626c8ca7ac2ca3f80317"
    sha256 cellar: :any,                 arm64_big_sur:  "9f9475a95ceb6946dcd33f1e3755957c8bda75011daf626c8ca7ac2ca3f80317"
    sha256 cellar: :any,                 ventura:        "be90e48d4b9a5f248d82c7a3a81bb5e731012b1fc7610f0b3732aefcb2133f40"
    sha256 cellar: :any,                 monterey:       "be90e48d4b9a5f248d82c7a3a81bb5e731012b1fc7610f0b3732aefcb2133f40"
    sha256 cellar: :any,                 big_sur:        "be90e48d4b9a5f248d82c7a3a81bb5e731012b1fc7610f0b3732aefcb2133f40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f6ad2318fe19759ea4c85cc1d5a53d3a2bdbed39e374fca1ea6661156c76fa6f"
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
