require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.2.1.tgz"
  sha256 "338b1cae517b5a376ad920bdee7bd19ea93c74bade07cc6b6bd6cc975f5cf633"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fef9222aa8db0f886c0482100a9c7bd288cd9ef36442438c8d5ede4c199c50b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2fb2750e722d7730bbfd4f46a9ca1b610a224a9e2794ea2d8c0ae0ec175b0617"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "270c2b94e1a474282c2612b5e95af0264b5ef0c9572e1532b1f582809aa08e88"
    sha256 cellar: :any_skip_relocation, ventura:        "405ef2fc2a3605747db870a749a9e6da940fbd632416fbdd4f7a80a13d6e27c7"
    sha256 cellar: :any_skip_relocation, monterey:       "9b7e13972922a032fd5ff2b910ab0f7c97f823d44691b830d728ce5b9d3beccc"
    sha256 cellar: :any_skip_relocation, big_sur:        "148815a6b171e3fae627367646c2bd04b58036932ebf978d92240ea9e424e6cb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "be945174f9465963cd2acd53c5a97196249247a368d2d2a825146a3ead26bf44"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
