class ArxivLatexCleaner < Formula
  include Language::Python::Virtualenv

  desc "Clean LaTeX code to submit to arXiv"
  homepage "https://github.com/google-research/arxiv-latex-cleaner"
  url "https://files.pythonhosted.org/packages/ba/75/626014f47d51aad0e6ef39a051ba7fe24a4e4f8b0bf23750909615d62864/arxiv_latex_cleaner-1.0.1.tar.gz"
  sha256 "d9fae07f82f8ad19704ff58fe4e1ed7fc668cc28ea6238c13bf5d687c988d79c"
  license "Apache-2.0"
  head "https://github.com/google-research/arxiv-latex-cleaner.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "13d4bc2fb0b6417dd149e8dc2bb053ba0846d67d959aae6f8c9287321368543c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "024da2f783e05aa704cba94f75160ad86253194cdf87f738a849aa375df907d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22e05dffefb48066a17e4ed6fb63436f454341b5fcc50b33fc37bde2126639d7"
    sha256 cellar: :any_skip_relocation, ventura:        "0891d0f0ea62f286f90890310d3c1b8c4d10af0fc07daf9e5e1bf269e72aaf57"
    sha256 cellar: :any_skip_relocation, monterey:       "93c637a795f3605087dc3fc5f968f2f026560628660221f51e715da240c85b3e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5be54dbb295f50ee167f2f200b1a50b9a52ed91c09b365ed42efea1258b18938"
    sha256 cellar: :any_skip_relocation, catalina:       "cad55a024117b20d31f8ea334f2c2c8260be8c95d31732731edce3c08062ccb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "52f9f057e82c56d4a251cd4d61485becb83e4a0ae4317fbfaf3bdfe46fe420b5"
  end

  depends_on "pillow"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  resource "absl-py" do
    url "https://files.pythonhosted.org/packages/79/c9/45ecff8055b0ce2ad2bfbf1f438b5b8605873704d50610eda05771b865a0/absl-py-1.4.0.tar.gz"
    sha256 "d2c244d01048ba476e7c080bd2c6df5e141d211de80223460d5b3b8a2a58433d"
  end

  resource "regex" do
    url "https://files.pythonhosted.org/packages/18/df/401fd39ffd50062ff1e0344f95f8e2c141de4fd1eca1677d2f29609e5389/regex-2023.6.3.tar.gz"
    sha256 "72d1a25bf36d2050ceb35b517afe13864865268dfb45910e2e17a84be6cbfeb0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    latexdir = testpath/"latex"
    latexdir.mkpath
    (latexdir/"test.tex").write <<~EOS
      % remove
      keep
    EOS
    system bin/"arxiv_latex_cleaner", latexdir
    assert_predicate testpath/"latex_arXiv", :exist?
    assert_equal "keep", (testpath/"latex_arXiv/test.tex").read.strip
  end
end
