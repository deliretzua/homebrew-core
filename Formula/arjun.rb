class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https://github.com/s0md3v/Arjun"
  url "https://files.pythonhosted.org/packages/51/cd/8eaadf3973a4e7bb519b885588b13348ddbe6d97ca06ecdcdda5f7a53dcb/arjun-2.2.1.tar.gz"
  sha256 "b1904add44c0c5a8241910b0555d7e252281187b7dadd16ebc0843dc768cb36e"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d6de4192a2bed46debf7428bbce37e30d8f22ae19f333b37df70c0b16f9898ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8b6849adebff0a65bd8b2d5d94226fa410090424711f031a34d1a1b12fc4c408"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1fe89651a6a6878618b528603415a5eda7bf0681788a42e02838f9e05a4ddc7b"
    sha256 cellar: :any_skip_relocation, ventura:        "4f9189f11df646c580a5464eaa5918f8f983b457f604c6e37f6a7cc26c720ee5"
    sha256 cellar: :any_skip_relocation, monterey:       "8bea002f1f521253bdb66ce0648cf89ee1260c24664314c352d456dbde497bde"
    sha256 cellar: :any_skip_relocation, big_sur:        "18327ce9b574ed29f3f0436e3494ad1c8761f1d7216295bafc9fd49492c6b700"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7658ff17e225887775db2e9ba03d17e6853430751032181e73cfc73b01ee322e"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "dicttoxml" do
    url "https://files.pythonhosted.org/packages/ee/c9/3132427f9e64d572688e6a1cbe3d542d1a03f676b81fb600f3d1fd7d2ec5/dicttoxml-1.7.16.tar.gz"
    sha256 "6f36ce644881db5cd8940bee9b7cb3f3f6b7b327ba8a67d83d3e2caa0538bf9d"
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
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/arjun -u https://mockbin.org/ -m GET")
    assert_match "No parameters were discovered", output
  end
end
