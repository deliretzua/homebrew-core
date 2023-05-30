class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/8d/e5/4097e94b7c45536499e03f319a30fd88173e9ec9da79fee2234559d29be8/coconut-3.0.2.tar.gz"
  sha256 "51934e6f6a70a0346827075c914a2904ef1e2f07f6d9d48f22132319fec442bc"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "09c8a4b0992cf3d6df2e3d8ed1b6299426480f0ebb7ba43420ad4323d535b879"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "938a843cbee131731bc3d9bcfc8bbed2ef23d35ff1bde9a1d386192402080e42"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f895edbf996d74ef0af9b16d3a0264079420849edd75ff05d368d05012918263"
    sha256 cellar: :any_skip_relocation, ventura:        "c8c8cce1563d1490b0cc969aecc8010b815d475dde1f8c8b8b4ce3536f0990f0"
    sha256 cellar: :any_skip_relocation, monterey:       "2a92c26fea8d3ade642bdd85881053841af81a74a925e2b8c0df3f8baf216042"
    sha256 cellar: :any_skip_relocation, big_sur:        "61ad7f2f0f1b5761a219257369a32645d492f77cd4ff993de94757957aee3c42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "392de157c0fcf638d1443f0df9a38ec72d09f1957a045e5f0ebef06eb6a417f3"
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

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/be/fc/3d12393d634fcb31d5f4231c28feaf4ead225124ba08021046317d5f450d/typing_extensions-4.6.2.tar.gz"
    sha256 "06006244c70ac8ee83fa8282cb188f697b8db25bc8b4df07be1873c43897060c"
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
