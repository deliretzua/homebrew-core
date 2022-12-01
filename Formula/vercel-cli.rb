require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.7.0.tgz"
  sha256 "68ee18ae1e702f2a634b791f82f4902ae8bba7504ae8460a8309c7a40d499471"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ee028d799995212519460012bcf04b8226eb40581dd6cc732a72b5ac2b8fb6c0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ee028d799995212519460012bcf04b8226eb40581dd6cc732a72b5ac2b8fb6c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ee028d799995212519460012bcf04b8226eb40581dd6cc732a72b5ac2b8fb6c0"
    sha256 cellar: :any_skip_relocation, ventura:        "3bf3fab1bd3d528788b4a7fed866df81906e72457bfcefddabd25b0cf62376c9"
    sha256 cellar: :any_skip_relocation, monterey:       "3bf3fab1bd3d528788b4a7fed866df81906e72457bfcefddabd25b0cf62376c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "3bf3fab1bd3d528788b4a7fed866df81906e72457bfcefddabd25b0cf62376c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "781651a3ea5f5bd6a1ec295084fda4838da543528f078515a184cdc83cfeb2eb"
  end

  depends_on "node"

  on_macos do
    depends_on "macos-term-size"
  end

  def install
    rm Dir["dist/{*.exe,xsel}"]
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    dist_dir = libexec/"lib/node_modules/vercel/dist"
    rm_rf dist_dir/"term-size"

    if OS.mac?
      # Replace the vendored pre-built term-size with one we build ourselves
      ln_sf (Formula["macos-term-size"].opt_bin/"term-size").relative_path_from(dist_dir), dist_dir
    end
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
