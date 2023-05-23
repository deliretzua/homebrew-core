class Goolabs < Formula
  include Language::Python::Virtualenv

  desc "Command-line tool for morphologically analyzing Japanese language"
  homepage "https://pypi.python.org/pypi/goolabs"
  url "https://files.pythonhosted.org/packages/ce/86/2d3b5bd85311ee3a7ae7a661b3619095431503cd0cae03048c646b700cad/goolabs-0.4.0.tar.gz"
  sha256 "4f768a5b98960c507f5ba4e1ca14d45e3139388669148a2750d415c312281527"
  license "MIT"
  revision 5

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f7234d5813a08707fb06104379dd8b19247e8582334514847e9d6a5e9ec8226b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff511d21670576540eb0ff2edac6e4b2112897d0d3e0f57fe6fe3b944a945336"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0e2e2ff10c0490f9f7c80481fce350b43a01edd749ef8a6b47a1248801df34f8"
    sha256 cellar: :any_skip_relocation, ventura:        "b0a07c5adae4d54a7fb5f4f69d36743ff940c8d14dde79c76326c7123179b840"
    sha256 cellar: :any_skip_relocation, monterey:       "0f7574fe2846be244376b5ef8c47e68fb73d7e8131c3c47eefa5af7719167e90"
    sha256 cellar: :any_skip_relocation, big_sur:        "b9500f78a17b7408f4ce68abd3d70f52d4955d9ffc1db2ff47dbd89a0ec321f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82f5bf0303201726a66fd956d1fbe5d4bb0e6e570134a07030e5e659ae716af9"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
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
    assert_match "Usage: goolabs morph", shell_output("#{bin}/goolabs morph test 2>&1", 2)
  end
end
