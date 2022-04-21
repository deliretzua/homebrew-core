class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/67/8f/79bda74492da08c09016a55942c5fe001fff199b8aaff7a6d82de1012fb4/pylint-2.13.7.tar.gz"
  sha256 "911d3a97c808f7554643bcc5416028cfdc42eae34ed129b150741888c688d5d5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af9fcda7280342eaab7ce44eaddd872ccb89a02dc56950d177472f3a2f2c0d9d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4340de116b60999a00d740defb45e1cae5863803ef6d800cc02c1911c91ba73"
    sha256 cellar: :any_skip_relocation, monterey:       "a51eecbfc39c8a8a7bf810f459a6e5c876cdf2a0aca2a14ba22fa4f3e986497a"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3b7ff3a444a16f17dc9de7b8bafd98e719226a330028e90569e62d35b714fe8"
    sha256 cellar: :any_skip_relocation, catalina:       "7fe96a4a1936d5dccc0d8f2ede34773302f7b4bed9b79f927330da8cc44dba67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b14b245d09e0555f77085c464804a792858d07f26e3d965d3d0032224f135c74"
  end

  depends_on "python@3.10"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/98/c8/e1de5f7dd1ff87c2dd9fce3e7e0dd5605946cdc480bdf70cf95d5bbbfd45/astroid-2.11.3.tar.gz"
    sha256 "4e5ba10571e197785e312966ea5efb2f5783176d4c1a73fa922d474ae2be59f7"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/57/b7/c4aa04a27040e6a3b09f5a652976ead00b66504c014425a7aad887aa8d7f/dill-0.3.4.zip"
    sha256 "9f9734205146b2b353ab3fec9af0070237b6ddae78452af83d2fca84d739e675"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/ab/e9/964cb0b2eedd80c92f5172f1f8ae0443781a9d461c1372a3ce5762489593/isort-5.10.1.tar.gz"
    sha256 "e8443a5e7a020e9d7f97f1d7d9cd17c88bcb3bc7e218bf9cf5095fe550be2951"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/75/93/3fc1cc28f71dd10b87a53b9d809602d7730e84cc4705a062def286232a9c/lazy-object-proxy-1.7.1.tar.gz"
    sha256 "d609c75b986def706743cdebe5e47553f4a5a1da9c5ff66d76013ef396b5a8a4"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c7/b4/3a937c7f8ee4751b38274c8542e02f42ebf3e080f1344c4a2aff6416630e/wrapt-1.14.0.tar.gz"
    sha256 "8323a43bd9c91f62bb7d4be74cc9ff10090e7ef820e27bfe8815c57e68261311"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
