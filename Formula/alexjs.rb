require "language/node"

class Alexjs < Formula
  desc "Catch insensitive, inconsiderate writing"
  homepage "https://alexjs.com"
  url "https://github.com/get-alex/alex/archive/11.0.0.tar.gz"
  sha256 "a7ee0de4cdb8a651a377537e495799fbf77a316c817df0ce33b7836794eca618"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4a23b144193badd2a84c6d596051f17bd31c1174af959d78ad4e043e29a1f53e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4a23b144193badd2a84c6d596051f17bd31c1174af959d78ad4e043e29a1f53e"
    sha256 cellar: :any_skip_relocation, monterey:       "cacb216ea94fd6e7b20fa41cbabeb44e26a965429f06f8f1ce33e9428175b35e"
    sha256 cellar: :any_skip_relocation, big_sur:        "cacb216ea94fd6e7b20fa41cbabeb44e26a965429f06f8f1ce33e9428175b35e"
    sha256 cellar: :any_skip_relocation, catalina:       "cacb216ea94fd6e7b20fa41cbabeb44e26a965429f06f8f1ce33e9428175b35e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a23b144193badd2a84c6d596051f17bd31c1174af959d78ad4e043e29a1f53e"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.txt").write "garbageman"
    assert_match "garbage collector", shell_output("#{bin}/alex test.txt 2>&1", 1)
  end
end
