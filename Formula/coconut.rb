class Coconut < Formula
  include Language::Python::Virtualenv

  desc "Simple, elegant, Pythonic functional programming"
  homepage "http://coconut-lang.org/"
  url "https://files.pythonhosted.org/packages/b0/ab/0d6b1a95bc554d35763451f17315d61c763fb4316bdc9a47129353b90e65/coconut-3.0.3.tar.gz"
  sha256 "700309695ee247947a3b9b451603dcc36a244d307d04be1841a87afb145810b5"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2cbb339f1cd255c07e2e00d733fad4e2adb00ed03244a61fa4237d7ba87b76fe"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c129ebf05f86e51801982175a408529e235f5776cf15f3c06eb7950c0b28ebca"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3201b59fc44926b19b45c46cdf237cb80a82d1310fb725671a8dcc7b78246efc"
    sha256 cellar: :any_skip_relocation, ventura:        "33d0d66bfc029d3af39ab5472395e1a464d1ee77543d65636a54361cdccc7e49"
    sha256 cellar: :any_skip_relocation, monterey:       "aba64e7f94ece622904975176a9b449b91974551470ba2046ae36a6be5648df9"
    sha256 cellar: :any_skip_relocation, big_sur:        "61aefb420fac64ce25905f3787726470ca432ae859e227a3187316660ffb7c5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "65f7819219649f35f0843a5d7d27cfef15d3e687f2170fad777313d36979c969"
  end

  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "cpyparsing" do
    url "https://files.pythonhosted.org/packages/8c/51/548830735273fbc91cdd0d583136577204089ea2ecf6ea2e85d135cf5230/cPyparsing-2.4.7.2.2.1.tar.gz"
    sha256 "4eb32b96ca130177bed9fde8e3e3ad8b6fb2dd95de60698a1adf5d53c5c5b953"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/9a/02/76cadde6135986dc1e82e2928f35ebeb5a1af805e2527fe466285593a2ba/prompt_toolkit-3.0.39.tar.gz"
    sha256 "04505ade687dc26dc4284b1ad19a83be2f2afe83e7a828ace0c72f3a1df72aac"
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
