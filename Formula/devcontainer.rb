require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.50.2.tgz"
  sha256 "65d66a4df6b2c017be9ae0f0a078169c65cd87276b9aca1d852a96af0372d8fb"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cc2a3b6790283243ce5f1193d009c17bd6e4bcf8ff1995066a8d1a64f348710e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc2a3b6790283243ce5f1193d009c17bd6e4bcf8ff1995066a8d1a64f348710e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc2a3b6790283243ce5f1193d009c17bd6e4bcf8ff1995066a8d1a64f348710e"
    sha256 cellar: :any_skip_relocation, ventura:        "2e918511c5d4af358aecfc4d95e14a83a3ac11d58c4a1a747b34752efcd33fb7"
    sha256 cellar: :any_skip_relocation, monterey:       "2e918511c5d4af358aecfc4d95e14a83a3ac11d58c4a1a747b34752efcd33fb7"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e918511c5d4af358aecfc4d95e14a83a3ac11d58c4a1a747b34752efcd33fb7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cad632a9400ca148a7b6ca91d7cdc9d326296a8bfe81a5f5c8ee73efe2591adc"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["DOCKER_HOST"] = "/dev/null"
    # Modified .devcontainer/devcontainer.json from CLI example:
    # https://github.com/devcontainers/cli#try-out-the-cli
    (testpath/".devcontainer.json").write <<~EOS
      {
        "name": "devcontainer-homebrew-test",
        "image": "mcr.microsoft.com/devcontainers/rust:0-1-bullseye"
      }
    EOS
    output = shell_output("#{bin}/devcontainer up --workspace-folder .", 1)
    assert_match '{"outcome":"error","message":"', output
  end
end
