require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.39.3.tgz"
  sha256 "1cd285c7a9ea7cdffd567b8230f80a1b9518a84eb345ce7727bef2c3bacaf5ab"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "25967c43b8d25e0d234a18b56a8f7eb9c9fd8e9c35abb2a964a44aab2032b530"
    sha256 cellar: :any,                 arm64_monterey: "25967c43b8d25e0d234a18b56a8f7eb9c9fd8e9c35abb2a964a44aab2032b530"
    sha256 cellar: :any,                 arm64_big_sur:  "25967c43b8d25e0d234a18b56a8f7eb9c9fd8e9c35abb2a964a44aab2032b530"
    sha256 cellar: :any,                 ventura:        "29ca19ce706c34cf8ea8f049394afb9c1cde6ce6fa9a4dbd9d7f0ed6dc455eb1"
    sha256 cellar: :any,                 monterey:       "29ca19ce706c34cf8ea8f049394afb9c1cde6ce6fa9a4dbd9d7f0ed6dc455eb1"
    sha256 cellar: :any,                 big_sur:        "29ca19ce706c34cf8ea8f049394afb9c1cde6ce6fa9a4dbd9d7f0ed6dc455eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7235f0f3a9ee0f2cbacbe8261f1860ab41dc6cac858ebfa3079b95489e3505e7"
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
