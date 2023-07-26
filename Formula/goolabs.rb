class Goolabs < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for morphologically analyzing Japanese language"
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://files.pythonhosted.org/packages/ce/86/2d3b5bd85311ee3a7ae7a661b3619095431503cd0cae03048c646b700cad/goolabs-0.4.0.tar.gz"
  sha256 "4f768a5b98960c507f5ba4e1ca14d45e3139388669148a2750d415c312281527"
  license "MIT"
  revision 6

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "687e077ba9a88d2cc337d117c73983aa52eba1f74e1a70ce8eed5e4c257682ab"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ce92832e501841a0047e37925789d48ef2d01748cf9530d6bf6f97fca81fa555"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b71cccba9bd028e2491025264b9316d6d676ccd3356be799a81fdf379afdab9"
    sha256 cellar: :any_skip_relocation, ventura:        "a6740d2f4f7ee02c00b0cebe378e1441fcbc6f2d841212fd0d62f886431d404f"
    sha256 cellar: :any_skip_relocation, monterey:       "37dcb53e2cd1886c7d519ac99b2320ad4a3f9bc9cdb41c8908ed77be068232f2"
    sha256 cellar: :any_skip_relocation, big_sur:        "bb5a896d144cf1031293a477f2ac0f4a0e58afbc2219a8bb1818757022dca95c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f949c309cad72a04621998ea1946297f3593b7e2ca2804d983d62cd10a47c84"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/72/bd/fedc277e7351917b6c4e0ac751853a97af261278a4c7808babafa8ef2120/click-8.1.6.tar.gz"
    sha256 "48ee849951919527a045bfe3bf7baa8a959c423134e1a5b98c05c20ba75a1cbd"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Usage: goolabs morph", shell_output("#{bin}/goolabs morph test 2>&1", 2)
  end
end
