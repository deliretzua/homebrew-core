class Ipython < Formula
  include Language::Python::Virtualenv

  desc "Interactive computing in Python"
  homepage "https://ipython.org/"
  url "https://files.pythonhosted.org/packages/f5/39/89664d8c3e4dfb0a73862cbbff8eb4028a1e3d4305da80ab0a493848ed9b/ipython-8.8.0.tar.gz"
  sha256 "f3bf2c08505ad2c3f4ed5c46ae0331a8547d36bf4b21a451e8ae80c0791db95b"
  license "BSD-3-Clause"
  head "https://github.com/ipython/ipython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fb09836dd44b816d6d87e4d6534e227e12fef9badfceb512bcc08f5ada786404"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "924adc0949e435df166cfe75929c929b85b2fc405b26734b9843c0a9d6d8c92f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c416539d50ea181823cbd5355abf65f610afbb61c062d799527c4b4b4796c5b6"
    sha256 cellar: :any_skip_relocation, ventura:        "7abdc037185d0d303db54828f250394e4503bc947dc16c5d53695c8b1b3bef1c"
    sha256 cellar: :any_skip_relocation, monterey:       "ff58f114157cf3f95a50e144849b520a704eed679e086399a52771454cfce3db"
    sha256 cellar: :any_skip_relocation, big_sur:        "fcdcee4bfd90d82cec424d3483097958344cff88b78b1233aca0dfff7a1ab215"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2fc64982f915afaedbd5482464e1e95bdfa1f1ce56939a9f37315a1a3cabc387"
  end

  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "appnope" do
    url "https://files.pythonhosted.org/packages/6a/cd/355842c0db33192ac0fc822e2dcae835669ef317fe56c795fb55fcddb26f/appnope-0.1.3.tar.gz"
    sha256 "02bd91c4de869fbb1e1c50aafc4098827a7a54ab2f39d9dcba6c9547ed920e24"
  end

  resource "asttokens" do
    url "https://files.pythonhosted.org/packages/c8/e3/b0b4f32162621126fbdaba636c152c6b6baec486c99f48686e66343d638f/asttokens-2.2.1.tar.gz"
    sha256 "4622110b2a6f30b77e1473affaa97e711bc2f07d3f10848420ff1898edbe94f3"
  end

  resource "backcall" do
    url "https://files.pythonhosted.org/packages/a2/40/764a663805d84deee23043e1426a9175567db89c8b3287b5c2ad9f71aa93/backcall-0.2.0.tar.gz"
    sha256 "5cbdbf27be5e7cfadb448baf0aa95508f91f2bbc6c6437cd9cd06e2a4c215e1e"
  end

  resource "decorator" do
    url "https://files.pythonhosted.org/packages/66/0c/8d907af351aa16b42caae42f9d6aa37b900c67308052d10fdce809f8d952/decorator-5.1.1.tar.gz"
    sha256 "637996211036b6385ef91435e4fae22989472f9d571faba8927ba8253acbc330"
  end

  resource "executing" do
    url "https://files.pythonhosted.org/packages/8f/ac/89ff37d8594b0eef176b7cec742ac868fef853b8e18df0309e3def9f480b/executing-1.2.0.tar.gz"
    sha256 "19da64c18d2d851112f09c287f8d3dbbdf725ab0e569077efb6cdcbd3497c107"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/15/02/afd43c5066de05f6b3188f3aa74136a3289e6c30e7a45f351546cab0928c/jedi-0.18.2.tar.gz"
    sha256 "bae794c30d07f6d910d32a7048af09b5a39ed740918da923c6b780790ebac612"
  end

  resource "matplotlib-inline" do
    url "https://files.pythonhosted.org/packages/d9/50/3af8c0362f26108e54d58c7f38784a3bdae6b9a450bab48ee8482d737f44/matplotlib-inline-0.1.6.tar.gz"
    sha256 "f887e5f10ba98e8d2b150ddcf4702c1e5f8b3a20005eb0f74bfdbd360ee6f304"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pexpect" do
    url "https://files.pythonhosted.org/packages/e5/9b/ff402e0e930e70467a7178abb7c128709a30dfb22d8777c043e501bc1b10/pexpect-4.8.0.tar.gz"
    sha256 "fc65a43959d153d0114afe13997d439c22823a27cefceb5ff35c2178c6784c0c"
  end

  resource "pickleshare" do
    url "https://files.pythonhosted.org/packages/d8/b6/df3c1c9b616e9c0edbc4fbab6ddd09df9535849c64ba51fcb6531c32d4d8/pickleshare-0.7.5.tar.gz"
    sha256 "87683d47965c1da65cdacaf31c8441d12b8044cdec9aca500cd78fc2c683afca"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/fb/93/180be2342f89f16543ec4eb3f25083b5b84eba5378f68efff05409fb39a9/prompt_toolkit-3.0.36.tar.gz"
    sha256 "3e163f254bef5a03b146397d7c1963bd3e2812f0964bb9a24e6ec761fd28db63"
  end

  resource "ptyprocess" do
    url "https://files.pythonhosted.org/packages/20/e5/16ff212c1e452235a90aeb09066144d0c5a6a8c0834397e03f5224495c4e/ptyprocess-0.7.0.tar.gz"
    sha256 "5c5d0a3b48ceee0b48485e0c26037c0acd7d29765ca3fbb5cb3831d347423220"
  end

  resource "pure-eval" do
    url "https://files.pythonhosted.org/packages/97/5a/0bc937c25d3ce4e0a74335222aee05455d6afa2888032185f8ab50cdf6fd/pure_eval-0.2.2.tar.gz"
    sha256 "2b45320af6dfaa1750f543d714b6d1c520a1688dec6fd24d339063ce0aaa9ac3"
  end

  resource "stack-data" do
    url "https://files.pythonhosted.org/packages/db/18/aa7f2b111aeba2cd83503254d9133a912d7f61f459a0c8561858f0d72a56/stack_data-0.6.2.tar.gz"
    sha256 "32d2dd0376772d01b6cb9fc996f3c8b57a357089dec328ed4b6553d037eaf815"
  end

  resource "traitlets" do
    url "https://files.pythonhosted.org/packages/56/48/0eb99357330a02974d537be8e4096bc58cfac1089e3153570119ccea7a40/traitlets-5.8.0.tar.gz"
    sha256 "6cc57d6dc28c85d5365961726ffd19b538739347749e13ebe34e03323a0e8f84"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    python3 = "python3.11"
    venv = virtualenv_create(libexec, python3)
    res = resources.reject { |r| r.name == "appnope" && OS.linux? }
    venv.pip_install res
    venv.pip_install_and_link buildpath

    # Install man page
    man1.install libexec/"share/man/man1/ipython.1"
  end

  test do
    assert_equal "4", shell_output("#{bin}/ipython -c 'print(2+2)'").chomp
  end
end
