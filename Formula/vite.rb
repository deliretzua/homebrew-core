require "language/node"

class Vite < Formula
  desc "Next generation frontend tooling. It's fast!"
  homepage "https://vitejs.dev/"
  url "https://registry.npmjs.org/vite/-/vite-4.4.1.tgz"
  sha256 "57d4c9d1f4eec71b322bee8fb8dd452c882fe500d13e8490cf220b8e014a72b3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b64047ae057e1626435f41e74116d137d59fe45eb9221860a800659e794ca1e2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b64047ae057e1626435f41e74116d137d59fe45eb9221860a800659e794ca1e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b64047ae057e1626435f41e74116d137d59fe45eb9221860a800659e794ca1e2"
    sha256 cellar: :any_skip_relocation, ventura:        "3dc0b80ec63b5ff321587791d564303dee0933ecb21c44b91a7a468a13dc1c6b"
    sha256 cellar: :any_skip_relocation, monterey:       "3dc0b80ec63b5ff321587791d564303dee0933ecb21c44b91a7a468a13dc1c6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "3dc0b80ec63b5ff321587791d564303dee0933ecb21c44b91a7a468a13dc1c6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3b00867576806f96c676b8fbb3f0b88d4706c6f4b7a5e0d98212f5aa884bf469"
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
