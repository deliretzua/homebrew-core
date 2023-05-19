class Xonsh < Formula
  include Language::Python::Virtualenv

  desc "Python-powered, cross-platform, Unix-gazing shell language and command prompt"
  homepage "https://xon.sh/"
  url "https://files.pythonhosted.org/packages/ab/4f/e8ce49c5582ccf43d9b968ebc4cc8fe24c3ece2900afaed927db65453a70/xonsh-0.14.0.tar.gz"
  sha256 "45a8aaabb17ce0d6d4eca9b709ecfd7ce1c8fb92162decd29a45bf88a60e9bf1"
  license "BSD-2-Clause-Views"
  head "https://github.com/xonsh/xonsh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c7e711795380adc4ba87798b4673ad58e30d74298a90f4a5bfedbad80300b52c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2c0d08e71602b9882ea6234eb34494dbb8c5654f0997ddc28dfcc6255a8bdd71"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5768185108e62abef7faae5e6ae9dc6a060b0c273dcca60e999d81316e1dbab2"
    sha256 cellar: :any_skip_relocation, ventura:        "7db7aea549f1d6614c3da213f85adb2b14945c2edde0e6705a4b0ddc273b21b9"
    sha256 cellar: :any_skip_relocation, monterey:       "13a1d03abeb1149dfa83e7ba4c59115ea69eeed61bb157b5cb9bfa98b59bd9a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c3f7501c07c7f39d5e3d8e8511c6cc5926459a11180d0c37b543ef9b6960ecee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f554276c3ef15bd4eeb885545e2f6c27f5909e809852d908a9e0554c8a688059"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  # Resources based on `pip3 install xonsh[ptk,pygments,proctitle]`
  # See https://xon.sh/osx.html#dependencies

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/4b/bb/75cdcd356f57d17b295aba121494c2333d26bfff1a837e6199b8b83c415a/prompt_toolkit-3.0.38.tar.gz"
    sha256 "23ac5d50538a9a38c8bde05fecb47d0b403ecd0662857a86f886f798563d5b9b"
  end

  resource "pyperclip" do
    url "https://files.pythonhosted.org/packages/a7/2c/4c64579f847bd5d539803c8b909e54ba087a79d01bb3aba433a95879a6c5/pyperclip-1.8.2.tar.gz"
    sha256 "105254a8b04934f0bc84e9c24eb360a591aaf6535c9def5f29d92af107a9bf57"
  end

  resource "setproctitle" do
    url "https://files.pythonhosted.org/packages/b5/47/ac709629ddb9779fee29b7d10ae9580f60a4b37e49bce72360ddf9a79cdc/setproctitle-1.3.2.tar.gz"
    sha256 "b9fb97907c830d260fa0658ed58afd48a86b2b88aac521135c352ff7fd3477fd"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "4", shell_output("#{bin}/xonsh -c 2+2")
  end
end
