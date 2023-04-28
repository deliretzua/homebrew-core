class Pyinvoke < Formula
  include Language::Python::Virtualenv

  desc "Pythonic task management & command execution"
  homepage "https://www.pyinvoke.org/"
  url "https://files.pythonhosted.org/packages/b0/29/a509301332714aacc10ff98b7fe6539a9a1f96b18698efe9666ceae1485c/invoke-2.1.0.tar.gz"
  sha256 "277894c57fa2b77f22ed3c7726fb8689773301e4497ccb2a59f19bc7bbbe5b4a"
  license "BSD-2-Clause"
  head "https://github.com/pyinvoke/invoke.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09b53320771acc6b8d031a903e844aedab84556dbfc1cd3b7d09481778f8da98"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09b53320771acc6b8d031a903e844aedab84556dbfc1cd3b7d09481778f8da98"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "09b53320771acc6b8d031a903e844aedab84556dbfc1cd3b7d09481778f8da98"
    sha256 cellar: :any_skip_relocation, ventura:        "bb3a3b00a3ca790c0bc8012e4f7a584b0a65452e513148f283d36b89df9bd6d1"
    sha256 cellar: :any_skip_relocation, monterey:       "bb3a3b00a3ca790c0bc8012e4f7a584b0a65452e513148f283d36b89df9bd6d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb3a3b00a3ca790c0bc8012e4f7a584b0a65452e513148f283d36b89df9bd6d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "40b169dcb888dd73ba6d3da2fc7fa871e215afa18157ddbd2029542f171af602"
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
