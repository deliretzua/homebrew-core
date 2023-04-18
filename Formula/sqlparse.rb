class Sqlparse < Formula
  include Language::Python::Virtualenv

  desc "Non-validating SQL parser"
  homepage "https://github.com/andialbrecht/sqlparse"
  url "https://files.pythonhosted.org/packages/65/16/10f170ec641ed852611b6c9441b23d10b5702ab5288371feab3d36de2574/sqlparse-0.4.4.tar.gz"
  sha256 "d446183e84b8349fa3061f0fe7f06ca94ba65b426946ffebe6e3e8295332420c"
  license "BSD-3-Clause"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d9aa28042ec77d514fd799d5935f3d2f0ba5bb5298778c04b9268d5b3695fa58"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9aa28042ec77d514fd799d5935f3d2f0ba5bb5298778c04b9268d5b3695fa58"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d9aa28042ec77d514fd799d5935f3d2f0ba5bb5298778c04b9268d5b3695fa58"
    sha256 cellar: :any_skip_relocation, ventura:        "5302c45462c979acba7f30f72c6226d9c34f95d040fe056836cc027a81b2838b"
    sha256 cellar: :any_skip_relocation, monterey:       "5302c45462c979acba7f30f72c6226d9c34f95d040fe056836cc027a81b2838b"
    sha256 cellar: :any_skip_relocation, big_sur:        "5302c45462c979acba7f30f72c6226d9c34f95d040fe056836cc027a81b2838b"
    sha256 cellar: :any_skip_relocation, catalina:       "5302c45462c979acba7f30f72c6226d9c34f95d040fe056836cc027a81b2838b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8c9bd813ff5e72590d662a3bdc8fcb56cc28de22454b0c5511fc4d49cd7fb9b2"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
    man1.install "docs/sqlformat.1"
  end

  test do
    expected = <<~EOS.chomp
      select *
        from foo
    EOS
    output = pipe_output("#{bin}/sqlformat - -a", "select * from foo", 0)
    assert_equal expected, output
  end
end
