class NodeSass < Formula
  require "language/node"

  desc "JavaScript implementation of a Sass compiler"
  homepage "https://github.com/sass/dart-sass"
  url "https://registry.npmjs.org/sass/-/sass-1.63.0.tgz"
  sha256 "309ec3ad092d2fbf253ee62793512fa4cb66fd1bc79950bee7efafcb049a3865"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5e2e24b27a6e9adc6fcc8e7e4a076ace54656ea73275ececb19df5b1cbffa223"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e2e24b27a6e9adc6fcc8e7e4a076ace54656ea73275ececb19df5b1cbffa223"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e2e24b27a6e9adc6fcc8e7e4a076ace54656ea73275ececb19df5b1cbffa223"
    sha256 cellar: :any_skip_relocation, ventura:        "5e2e24b27a6e9adc6fcc8e7e4a076ace54656ea73275ececb19df5b1cbffa223"
    sha256 cellar: :any_skip_relocation, monterey:       "5e2e24b27a6e9adc6fcc8e7e4a076ace54656ea73275ececb19df5b1cbffa223"
    sha256 cellar: :any_skip_relocation, big_sur:        "5e2e24b27a6e9adc6fcc8e7e4a076ace54656ea73275ececb19df5b1cbffa223"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d63bee06735948ae0c4a178877372233bc88e0b7b069a75dca764835d0b7e79f"
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
