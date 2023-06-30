require "language/node"

class Devcontainer < Formula
  desc "Reference implementation for the Development Containers specification"
  homepage "https://containers.dev"
  url "https://registry.npmjs.org/@devcontainers/cli/-/cli-0.47.0.tgz"
  sha256 "c6170dc0bcf427c98b289a8737f5ec3be101fcdf5684205bbc8a130366cbf288"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "8043b5edf0609149df66274e53690126d7c9245860da1b0919867ffd56512ecc"
    sha256                               arm64_monterey: "df5086a334a0d34675d9854386690e77e28c930557f2e9f00aa384df3a292848"
    sha256                               arm64_big_sur:  "b2dc9e7615d2536c533bfe1993807e3d702ac17369a0dd40d678ba4627f5afac"
    sha256                               ventura:        "8199df3cbef7999a8f6e9592b18cfc7feb8c78256b14f5fec31e72247b547a58"
    sha256                               monterey:       "9ad0f29a1c447644ace44f3512cedb3898ec71ffec12ffda2dd4c148b1c984d5"
    sha256                               big_sur:        "2fa6dcaacca6d3bf0d2cd7ef90691cec04fe1b12e94103ae7a67841fe074f411"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1d3693aa2f7c56d65a58d5f0f9559f734a88517969c22bead8a4e5692c3d65b5"
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
