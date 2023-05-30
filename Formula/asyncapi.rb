require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.45.1.tgz"
  sha256 "7e8fd82ed9328f16170abd3d499b6303d110e4f4811fc3d4e46eb7467de55560"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "844d32411ad8c7a3a0c7c387dd0eca3744de05be15a54f2a0b02ce452bc5d686"
    sha256 cellar: :any,                 arm64_monterey: "844d32411ad8c7a3a0c7c387dd0eca3744de05be15a54f2a0b02ce452bc5d686"
    sha256 cellar: :any,                 arm64_big_sur:  "844d32411ad8c7a3a0c7c387dd0eca3744de05be15a54f2a0b02ce452bc5d686"
    sha256 cellar: :any,                 ventura:        "59dc0b0d07eabecc4ab13595b3a690eff0eb6dde541232e1f40ee3c5e2b21811"
    sha256 cellar: :any,                 monterey:       "59dc0b0d07eabecc4ab13595b3a690eff0eb6dde541232e1f40ee3c5e2b21811"
    sha256 cellar: :any,                 big_sur:        "59dc0b0d07eabecc4ab13595b3a690eff0eb6dde541232e1f40ee3c5e2b21811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0416e2a06d5b7d446cd482562a4942094ecf1f72199975f1d084d1074951dc27"
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
