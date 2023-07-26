class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/19/07/24a57a4b12b8ea09f61436db7b312676aa2e526a34dbd0f2866e3e563e1a/pylint-2.17.5.tar.gz"
  sha256 "f7b601cbc06fef7e62a754e2b41294c2aa31f1cb659624b9a85bcba29eaf8252"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23d174700d9823b43e673c382b0f67a18a38c3d63b1eedc1442cca12eb47b47c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bf6e9a9203d974ec7672ee05bae5df72d6e225236f1155880bdc156d0bb86e55"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a730c157225e9bd69107768adba10430043be83e431fe5bb0db2eec896984d8a"
    sha256 cellar: :any_skip_relocation, ventura:        "01efed4dcde494b30275ac55fe71d35e48b3b5b09701ab993eed9ed5be6fec50"
    sha256 cellar: :any_skip_relocation, monterey:       "1821a18387ee7fb20de0f32da65eac61a1f00259e9af562834a8c8063e970036"
    sha256 cellar: :any_skip_relocation, big_sur:        "1199c825dfb640ef59fa0ffc5c8f607d31ce741482de0a3c751e2d938daa6c39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "90e6abac99d01856617e3219e4c048eb085d02939555073bb9bcd773db55e1ab"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/d5/05/2c2ef3504e32a22b224614d45c590abb5be417cfed47ee63bf6089c3ae56/astroid-2.15.6.tar.gz"
    sha256 "903f024859b7c7687d7a7f3a3f73b17301f8e42dfd9cc9df9d4418172d3e2dbd"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/c4/31/54dd222e02311c2dbc9e680d37cbd50f4494ce1ee9b04c69980e4ec26f38/dill-0.3.7.tar.gz"
    sha256 "cc1c8b182eb3013e24bd475ff2e9295af86c1a38eb1aff128dac8962a9ce3c03"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/20/c0/8bab72a73607d186edad50d0168ca85bd2743cfc55560c9d721a94654b20/lazy-object-proxy-1.9.0.tar.gz"
    sha256 "659fb5809fa4629b8a1ac5106f669cfc7bef26fbb389dda53b3e010d1ac4ebae"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/a1/70/c1d14c0c58d975f06a449a403fac69d3c9c6e8ae2a529f387d77c29c2e56/platformdirs-3.9.1.tar.gz"
    sha256 "1b42b450ad933e981d56e59f1b97495428c9bd60698baab9f3eb3d00d5822421"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/10/37/dd53019ccb72ef7d73fff0bee9e20b16faff9658b47913a35d79e89978af/tomlkit-0.11.8.tar.gz"
    sha256 "9330fc7faa1db67b541b28e62018c17d20be733177d290a13b24c62d1614e0c3"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  def install
    virtualenv_install_with_resources

    # we depend on isort, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    isort = Formula["isort"].opt_libexec
    (libexec/site_packages/"homebrew-isort.pth").write isort/site_packages
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
