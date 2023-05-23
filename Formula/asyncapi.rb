require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.40.9.tgz"
  sha256 "3b59478c8e87afa52a816988a893186e59b6bd3a7e68f10d8c365b0e976b9ec7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1fa54cf0e3a620dfb2bb09d64e9c0592bf3714e55639d271a89aa9ee3688352a"
    sha256 cellar: :any,                 arm64_monterey: "1fa54cf0e3a620dfb2bb09d64e9c0592bf3714e55639d271a89aa9ee3688352a"
    sha256 cellar: :any,                 arm64_big_sur:  "1fa54cf0e3a620dfb2bb09d64e9c0592bf3714e55639d271a89aa9ee3688352a"
    sha256 cellar: :any,                 ventura:        "63abc25e7a22b453102cbae52717c282a1e067877b960a7c6295fed71f0c5c3f"
    sha256 cellar: :any,                 monterey:       "63abc25e7a22b453102cbae52717c282a1e067877b960a7c6295fed71f0c5c3f"
    sha256 cellar: :any,                 big_sur:        "63abc25e7a22b453102cbae52717c282a1e067877b960a7c6295fed71f0c5c3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "17646609a8f577098b83ff4bc7ee1ec4b0043c4b3cfca375778f22b546a497e6"
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
