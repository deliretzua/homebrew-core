class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/24/f7/efd7ba4c501ee49295b55f2e95ba102dbe987a7811e79bce6d8c02a1ad03/coconut-3.0.0.tar.gz"
  sha256 "a43e6b42f0bff1e4a868e2d1aa24e9a9dca9a106ab72047d03a1d73e9a4dc378"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b5ccdba9ce83f347a3ae8a6d0e1e837f1525c1bd035e6e35cf31cd59fa54f9ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b5094974db4f73a4c2f9e68b6fa8f4768a84b90967e7137d80ff226ad04ff65a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38d9677981288784d7d8b9d78d78100263a359602c3ccf435406b6926faece3a"
    sha256 cellar: :any_skip_relocation, ventura:        "104919aa3b1e68cb13242001a67792046349e4121aaf9cd6175a629ff0373726"
    sha256 cellar: :any_skip_relocation, monterey:       "93cc736e5b7a77166f862c9cea8895ed002707be19150511423d70f772e781c3"
    sha256 cellar: :any_skip_relocation, big_sur:        "6e94622a988049042dd04719ae4ca0bc51789c904d9926ef854fd3b223735105"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bde3be5ad7d86ea8157246363f4e55c79b5bd3e58b2afa54023cebd02293740f"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "cpyparsing" do
    url "https://files.pythonhosted.org/packages/d0/44/49b91c35e074634560c0b70adc7fa3792976d6a51485422e3a3272bfd7c3/cPyparsing-2.4.7.1.2.1.tar.gz"
    sha256 "6a13dbfed649bf07d59fd1b8d99b5d3351a8622ded959118fc19eb8b88399bcd"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/4b/bb/75cdcd356f57d17b295aba121494c2333d26bfff1a837e6199b8b83c415a/prompt_toolkit-3.0.38.tar.gz"
    sha256 "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"hello.coco").write <<~EOS
      "hello, world!" |> print
    EOS
    assert_match "hello, world!", shell_output("#{bin}/coconut -r hello.coco")
  end
end
