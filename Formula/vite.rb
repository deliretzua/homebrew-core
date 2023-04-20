require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.3.0.tgz"
  sha256 "be20c474c5a20f50255787ae1b51137b5a1ef83623fc82c6f3d490310240d10f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5770f0bf8b8e46b931288480227d2d6afb9f1b296b67782b686d9f2e4648a9b3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5770f0bf8b8e46b931288480227d2d6afb9f1b296b67782b686d9f2e4648a9b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5770f0bf8b8e46b931288480227d2d6afb9f1b296b67782b686d9f2e4648a9b3"
    sha256 cellar: :any_skip_relocation, ventura:        "e683b1974c44870066e7359354e3fbd44bccd8aa8a9cdf46f5cddb0c9d0711ea"
    sha256 cellar: :any_skip_relocation, monterey:       "e683b1974c44870066e7359354e3fbd44bccd8aa8a9cdf46f5cddb0c9d0711ea"
    sha256 cellar: :any_skip_relocation, big_sur:        "e683b1974c44870066e7359354e3fbd44bccd8aa8a9cdf46f5cddb0c9d0711ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7c74c5a340901ebcd3a600b02dd2f43428002b1b00d36da20ed369b345f6313a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
    deuniversalize_machos
  end

  test do
    port = free_port
    fork do
      system bin/"vite", "preview", "--port", port
    end
    sleep 2
    assert_match "Cannot GET /", shell_output("curl -s localhost:#{port}")
  end
end
