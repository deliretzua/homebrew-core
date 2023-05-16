require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.3.1.tgz"
  sha256 "3628e86ddb0f7fbbf2f151c7965d61b577ea72ccdcb65ef1cd5557dae1b620d4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "69c939dbfde42cca0e82483de7df7ab61822ca086f341594c19f4231ec262c99"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "df4ac1e503f8b23a1551ada3b9cb8da58af7d95bc4e123233ca4c0d032efe5df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b3eeb2e995a3e6acec7d0b6e8bc8d1b4f98303b65881021487f766b4ec990ad"
    sha256 cellar: :any_skip_relocation, ventura:        "d887b5355abe8e211a1bfe9ab25ef49ffe9511938f4adcd8b8326e0319397f5e"
    sha256 cellar: :any_skip_relocation, monterey:       "0684838b13626da8ee605c2cc2a1ae4e063ab5cc7bcafac3bc3e6ddfd64f0dfe"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cae6bb9947afeefbc3351b793924f6f7cf8a80ed175fbd6f6c296ba7550db8d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5c4a0dee9e767ada5bd5e17255fa559f588759315d06612c09ff77e793360886"
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
