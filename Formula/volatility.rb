class Volatility < Formula
  include Language::Python::Virtualenv

  desc "Advanced memory forensics framework"
  homepage "https://github.com/volatilityfoundation/volatility3"
  url "https://files.pythonhosted.org/packages/d6/e5/b9a3c053dcca7688477ac004a9d6e700cd1a29272ddee4188f09f1bc0d62/volatility3-2.4.1.tar.gz"
  sha256 "6ba2735a6d77727a8b038286e55a24e7048fc68b1d7a306183938b940d64c029"
  license :cannot_represent
  version_scheme 1
  head "https://github.com/volatilityfoundation/volatility3.git", branch: "develop"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_ventura:  "8e525e6512b5c1bc66ef23b00e1b5ae9c0de811141e320a144d3aa59d78e14e0"
    sha256 cellar: :any,                 arm64_monterey: "05fee3aaadf580980a8fa78d2aa6c5ecb70e4c21aff0f8fc490eb78e0b825cfc"
    sha256 cellar: :any,                 arm64_big_sur:  "a81affb49870e7495882b2fa8c36cf98e511178caab8786e04479c311c1230b8"
    sha256 cellar: :any,                 ventura:        "e9a9339ca07327e7692eb5740cf5d528fdcda6dde362e11c5222e6c379cd11a1"
    sha256 cellar: :any,                 monterey:       "b8353e0c75ca7b56cfffb77c6fe2fedf6c863f1efc434f16e3681d716d92e3aa"
    sha256 cellar: :any,                 big_sur:        "42de8340b95a5fb2c35863dd6f52db5db2ddf543a8e5ff265eb68d183da20941"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4d80141455f26ffff4cdf47524e25818f37870f64ef715b3cab67e470c86eaca"
  end

  depends_on "python@3.11"
  depends_on "yara"

  # Extra resources are from `requirements.txt`: https://github.com/volatilityfoundation/volatility3#requirements
  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "capstone" do
    url "https://files.pythonhosted.org/packages/f2/ae/21dbb3ccc30d5cc9e8cdd8febfbf5d16d93b8c10e595280d2aa4631a0d1f/capstone-4.0.2.tar.gz"
    sha256 "2842913092c9b69fd903744bc1b87488e1451625460baac173056e1808ec1c66"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "jsonschema" do
    url "https://files.pythonhosted.org/packages/36/3d/ca032d5ac064dff543aa13c984737795ac81abc9fb130cd2fcff17cfabc7/jsonschema-4.17.3.tar.gz"
    sha256 "0f864437ab8b6076ba6707453ef8f98a6a0d512a80e93f8abdb676f737ecb60d"
  end

  resource "pefile" do
    url "https://files.pythonhosted.org/packages/78/c5/3b3c62223f72e2360737fd2a57c30e5b2adecd85e70276879609a7403334/pefile-2023.2.7.tar.gz"
    sha256 "82e6114004b3d6911c77c3953e3838654b04511b8b66e8583db70c65998017dc"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b8/2e/cf9cfd1ae6429381d3d9c14c8df79d91ae163929972f245a76058ea9d37d/pycryptodome-3.17.tar.gz"
    sha256 "bce2e2d8e82fcf972005652371a3e8731956a0c1fbb719cc897943b3695ad91b"
  end

  resource "pyrsistent" do
    url "https://files.pythonhosted.org/packages/bf/90/445a7dbd275c654c268f47fa9452152709134f61f09605cf776407055a89/pyrsistent-0.19.3.tar.gz"
    sha256 "1a2994773706bbb4995c31a97bc94f1418314923bd1048c6d964837040376440"
  end

  resource "yara-python" do
    url "https://files.pythonhosted.org/packages/47/c5/23148d89227e8f2fa01d3b65094cddd36689c2aba9d6f63f8baff633138d/yara-python-4.3.0.tar.gz"
    sha256 "3f85ec4730e4a337c217f96227307e625aa47fc3b5aaaa54da996f6d35c9bc42"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"vol", "--help"
  end
end
