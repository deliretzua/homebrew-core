require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.3.4.tgz"
  sha256 "b6cc6ec2261a7282e8b3c409c05af2ab721b399debd732ef0a83de9723b7744b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5f559f8b7b89c6860ff6fdfcce9cbf960c84aed1f90d1c6d136733d49e7550af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f559f8b7b89c6860ff6fdfcce9cbf960c84aed1f90d1c6d136733d49e7550af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f559f8b7b89c6860ff6fdfcce9cbf960c84aed1f90d1c6d136733d49e7550af"
    sha256 cellar: :any_skip_relocation, ventura:        "9540da5ac32df03bb565c3c7256021f394b636e15565bdeb20997048909a01f0"
    sha256 cellar: :any_skip_relocation, monterey:       "9540da5ac32df03bb565c3c7256021f394b636e15565bdeb20997048909a01f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9540da5ac32df03bb565c3c7256021f394b636e15565bdeb20997048909a01f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "caea866b7790101869551bb3098f4d45082907615249a1f597d96f703cb2dea6"
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
