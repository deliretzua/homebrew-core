require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.40.9.tgz"
  sha256 "3b59478c8e87afa52a816988a893186e59b6bd3a7e68f10d8c365b0e976b9ec7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "21403dbb6e261c874aaa01c9bdc40ce7d01be0639f9b4f3ae65423dea0ce8ddf"
    sha256 cellar: :any,                 arm64_monterey: "21403dbb6e261c874aaa01c9bdc40ce7d01be0639f9b4f3ae65423dea0ce8ddf"
    sha256 cellar: :any,                 arm64_big_sur:  "21403dbb6e261c874aaa01c9bdc40ce7d01be0639f9b4f3ae65423dea0ce8ddf"
    sha256 cellar: :any,                 ventura:        "35b55c0408ac912ad485c7fb89d6540287009e557f46bc13987d64b1c1a6a8e3"
    sha256 cellar: :any,                 monterey:       "35b55c0408ac912ad485c7fb89d6540287009e557f46bc13987d64b1c1a6a8e3"
    sha256 cellar: :any,                 big_sur:        "35b55c0408ac912ad485c7fb89d6540287009e557f46bc13987d64b1c1a6a8e3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c78ba013b7851d232fb78d4a1a8f8790f4ed873752c61b82d69d71fc425ed029"
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
