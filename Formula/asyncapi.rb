require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.43.0.tgz"
  sha256 "b54fa47a63c633d410a4011ca4b0c0203f276e26f4d605ad518ca854f5797a29"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "de9ce038595ddeb7f0a59bb3162210db87526e391d54c88d2e7a67c48a029593"
    sha256 cellar: :any,                 arm64_monterey: "de9ce038595ddeb7f0a59bb3162210db87526e391d54c88d2e7a67c48a029593"
    sha256 cellar: :any,                 arm64_big_sur:  "de9ce038595ddeb7f0a59bb3162210db87526e391d54c88d2e7a67c48a029593"
    sha256 cellar: :any,                 ventura:        "8d5c633b4de21e3eba35fc6896a564b8b6b71222c6ec1ec951c5d62548807f28"
    sha256 cellar: :any,                 monterey:       "8d5c633b4de21e3eba35fc6896a564b8b6b71222c6ec1ec951c5d62548807f28"
    sha256 cellar: :any,                 big_sur:        "8d5c633b4de21e3eba35fc6896a564b8b6b71222c6ec1ec951c5d62548807f28"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a1284068718d4d7df9f1fbf2611ca6bf77d2e1b8791ca313a96076a335017af"
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
