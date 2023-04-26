class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.62.1.tgz"
  sha256 "dbee140ec1169f99a8b4fc23eaa1c34b7a038f03e3bcd7e1f450b5307d47961c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "328a0be7e8bc32f037689302df45241605b34a133fe5f230fc452c709403b83e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "328a0be7e8bc32f037689302df45241605b34a133fe5f230fc452c709403b83e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "328a0be7e8bc32f037689302df45241605b34a133fe5f230fc452c709403b83e"
    sha256 cellar: :any_skip_relocation, ventura:        "328a0be7e8bc32f037689302df45241605b34a133fe5f230fc452c709403b83e"
    sha256 cellar: :any_skip_relocation, monterey:       "328a0be7e8bc32f037689302df45241605b34a133fe5f230fc452c709403b83e"
    sha256 cellar: :any_skip_relocation, big_sur:        "328a0be7e8bc32f037689302df45241605b34a133fe5f230fc452c709403b83e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d6b94fea2bd9748df7846faa161c509404cc3d6a83ccbfd29e04a1f240a84aa"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.scss").write <<~EOS
      div {
        img {
          border: 0px;
        }
      }
    EOS

    assert_equal "div img{border:0px}",
    shell_output("#{bin}/sass --style=compressed test.scss").strip
  end
end
