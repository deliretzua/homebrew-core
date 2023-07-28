require "language/node"

class Asyncapi < Formula
  desc "All in one CLI for all AsyncAPI tools"
  homepage "https://github.com/asyncapi/cli"
  url "https://registry.npmjs.org/@asyncapi/cli/-/cli-0.51.4.tgz"
  sha256 "54a451e7d8e560adc4bdf2c635f30403d284620fa53bc73b5037323170d0cf04"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1af455d3b50b1c101232064d7863001d9b2e0f420fc86532d2fa5d53d5ea9774"
    sha256 cellar: :any,                 arm64_monterey: "1af455d3b50b1c101232064d7863001d9b2e0f420fc86532d2fa5d53d5ea9774"
    sha256 cellar: :any,                 arm64_big_sur:  "1af455d3b50b1c101232064d7863001d9b2e0f420fc86532d2fa5d53d5ea9774"
    sha256 cellar: :any,                 ventura:        "b8a77337fb74e77f33440a189298ce7dc150bea33bb4f36d72a738aafa449502"
    sha256 cellar: :any,                 monterey:       "b8a77337fb74e77f33440a189298ce7dc150bea33bb4f36d72a738aafa449502"
    sha256 cellar: :any,                 big_sur:        "b8a77337fb74e77f33440a189298ce7dc150bea33bb4f36d72a738aafa449502"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64830fb8f2114ba28edbaa78766eea84e9c1580311122888b1e65eaacded7358"
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
