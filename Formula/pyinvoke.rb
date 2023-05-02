class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/fc/ed/75616c70c3e96bdfec93f6a171e87f0463d9da21b061ff8af8ae7ecda17e/invoke-2.1.1.tar.gz"
  sha256 "7dcf054c4626b89713da650635c29e9dfeb8a1dd0a14edc60bd3e16f751292ff"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8e7856a4a27b4cb5ac99b43b29ad2b44d98ea583990b9f12f5c88e68f10396c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b29aec348ad752b4862c21386e72a6d9c456c832bb64d6056959e7609d194c0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bbcc7f34c77bb10d512886d4503ca84a0765362fc416f61816318e584af4f94a"
    sha256 cellar: :any_skip_relocation, ventura:        "9a5bbea74424ece0ea72c3f2ad51969c5c2c3c5fbf24a9bec5039f32a730179a"
    sha256 cellar: :any_skip_relocation, monterey:       "7cc84b15ae8275a61048c6981a05b277bcaf2ea0eca2fa6199493846b315976f"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a70ce5b397d03ae22032d2e7464ca17afd974fdfe8959876ecf0e7eba13dc83"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96ae727d1cca333c1f4e55dd2dd0a2bea1419ce2e48f9411d19da3502efabb0d"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"tasks.py").write <<~EOS
      from invoke import run, task

      @task
      def clean(ctx, extra=''):
          patterns = ['foo']
          if extra:
              patterns.append(extra)
          for pattern in patterns:
              run("rm -rf {}".format(pattern))
    EOS
    (testpath/"foo"/"bar").mkpath
    (testpath/"baz").mkpath
    system bin/"invoke", "clean"
    refute_predicate testpath/"foo", :exist?, "\"pyinvoke clean\" should have deleted \"foo\""
    assert_predicate testpath/"baz", :exist?, "pyinvoke should have left \"baz\""
    system bin/"invoke", "clean", "--extra=baz"
    refute_predicate testpath/"foo", :exist?, "\"pyinvoke clean-extra\" should have still deleted \"foo\""
    refute_predicate testpath/"baz", :exist?, "pyinvoke clean-extra should have deleted \"baz\""
  end
end
