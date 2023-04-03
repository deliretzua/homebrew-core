class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/00/06/24c4d02c247fbca313fc9fda9033996d337f93c29a02ccd4f031c7c80d5d/pylint-2.17.2.tar.gz"
  sha256 "1b647da5249e7c279118f657ca28b6aaebb299f86bf92affc632acf199f7adbb"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "85aea59f953e67951bb2cf2b3caed7f4be0b197850d634084e37ac190e8ef2e0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "65c9728306a5dea3b8688df9ca44d976d02ff693b755213490059c62b736338b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "76554694ba780fdb415523b63e36ea20c666b621f68b3024d5a0126fe0c2c844"
    sha256 cellar: :any_skip_relocation, ventura:        "b99c4cac7d007f1cc7a8315cda804e217a6e175934f9eaf5374ad47ca4e6072a"
    sha256 cellar: :any_skip_relocation, monterey:       "314d6579f7ba5a0ad42c955c70eb0b306d4e59c42fdaf227c57c39156d6f212f"
    sha256 cellar: :any_skip_relocation, big_sur:        "156bc7ad27a956b6efe3ce90f280a719edce206ca01a8de688736ef0a84275d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61203bbda0750bc5728c8b449c81c0116e88ff0a490135029751f454a4af7011"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/80/95/a17a3c963bc77a8be61ee0a1aea3cffb1a10bdfdf1ad836c141fd079ed03/astroid-2.15.2.tar.gz"
    sha256 "6e61b85c891ec53b07471aec5878f4ac6446a41e590ede0f2ce095f39f7d49dd"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
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
    url "https://files.pythonhosted.org/packages/15/04/3f882b46b454ab374ea75425c6f931e499150ec1385a73e55b3f45af615a/platformdirs-3.2.0.tar.gz"
    sha256 "d5b638ca397f25f979350ff789db335903d7ea010ab28903f57b27e1b16c2b08"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/4d/4e/6cb8a301134315e37929763f7a45c3598dfb21e8d9b94e6846c87531886c/tomlkit-0.11.7.tar.gz"
    sha256 "f392ef70ad87a672f02519f99967d28a4d3047133e2d1df936511465fbb3791d"
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
