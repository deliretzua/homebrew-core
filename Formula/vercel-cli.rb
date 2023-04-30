require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-29.0.3.tgz"
  sha256 "944aa9bba09897faacd975c181d6c2a2f36982a4cd22a76a063d8d4bb8383a9f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5777a2f782ac07378da3c42ce4cc04e62e4cd8634e22c8445f6ecdd69279e836"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0bdc49f645d407106bb67064d967cec5b3cc8aa79d9e0a4a955f604285e950fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a056713502687bb0a5ba091dbe20378415ddc6629e9407413797f0c801676373"
    sha256 cellar: :any_skip_relocation, ventura:        "eeb2c30b96a89203050872819a6e6de607b9aaddaa4f3a8994bf10622699fc6c"
    sha256 cellar: :any_skip_relocation, monterey:       "4ea71246f0a388a4488ca5322f812f90a86d016f5bf6afec9ad504210641f26d"
    sha256 cellar: :any_skip_relocation, big_sur:        "f42f7ac38ae8e76f58d6ac48ccbe8faf9b6a012aaae427a2ffae4d2c79eef5b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "376e5b81f083bdf58e1d5ac82ad4ab9a0e126a6f2ab7b372b3504e416852cce7"
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
