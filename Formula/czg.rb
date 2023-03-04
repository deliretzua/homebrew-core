require "language/node"

class Czg < Formula
  desc "Interactive Commitizen CLI that generate standardized commit messages"
  homepage "https://github.com/Zhengqbbb/cz-git"
  url "https://registry.npmjs.org/czg/-/czg-1.5.2.tgz"
  sha256 "d4cb49747696eae441f2c1ae2571ce3bf39e02c6a8531a82ddcbcdb0a1d76047"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "da6e376e4832ee08a4bfa8b77ac0980fd47ab5a573d6107fbf310ccf27297114"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_equal "#{version}\n", shell_output("#{bin}/czg --version")
    # test: git staging verifies is working
    system "git", "init"
    assert_match ">>> No files added to staging! Did you forget to run `git add` ?",
      shell_output("NO_COLOR=1 #{bin}/czg 2>&1", 1)
  end
end
