class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/d8/90/0ba582183dc880d457484fbe44abf39f0d29f9bdd74733107921b4f811b6/jc-1.15.1.tar.gz"
  sha256 "1afb297d16860f701756812148c3c98ee07a74d14eda01c74ab446e2c5a87bbe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f7be98c538e90478cd07dbfb156083bb3419e3025fdfd9e0517ea6b25d1ab861"
    sha256 cellar: :any_skip_relocation, big_sur:       "ed90af79616bac1430bc0d5d9f9dcbabe868b847d86b85190dc007cacbd67793"
    sha256 cellar: :any_skip_relocation, catalina:      "c8ae079390aefbd19e660b088962f458c4c16be4da122867615569d881db90d0"
    sha256 cellar: :any_skip_relocation, mojave:        "8ce342297442d6463b75b5fc644ca8aa3c1bcbc1df4479544b15ed03698b0fa8"
  end

  depends_on "python@3.9"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/15/9d/bc9047ca1eee944cc245f3649feea6eecde3f38011ee9b8a6a64fb7088cd/Pygments-2.8.1.tar.gz"
    sha256 "2656e1a6edcdabf4275f9a3640db59fd5de107d88e8663c5d4e9a0fa62f77f94"
  end

  resource "ruamel.yaml" do
    url "https://files.pythonhosted.org/packages/62/cf/148028462ab88a71046ba0a30780357ae9e07125863ea9ca7808f1ea3798/ruamel.yaml-0.17.4.tar.gz"
    sha256 "44bc6b54fddd45e4bc0619059196679f9e8b79c027f4131bb072e6a22f4d5e28"
  end

  resource "ruamel.yaml.clib" do
    url "https://files.pythonhosted.org/packages/fa/a1/f9c009a633fce3609e314294c7963abe64934d972abea257dce16a15666f/ruamel.yaml.clib-0.2.2.tar.gz"
    sha256 "2d24bd98af676f4990c4d715bcdc2a60b19c56a3fb3a763164d2d8ca0e806ba7"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/58/40/0d783e14112e064127063fbf5d1fe1351723e5dfe9d6daad346a305f6c49/xmltodict-0.12.0.tar.gz"
    sha256 "50d8c638ed7ecb88d90561beedbf720c9b4e851a9fa6c47ebd64e99d166d8a21"
  end

  def install
    virtualenv_install_with_resources
    man1.install "jc/man/jc.1.gz"
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n", \
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
