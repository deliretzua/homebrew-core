class Grip < Formula
  include Language::Python::Virtualenv

  desc "GitHub Markdown previewer"
  homepage "https://github.com/joeyespo/grip"
  url "https://files.pythonhosted.org/packages/b9/7b/013fad0e29839decbdf8d3b96dbbfa155cbf0b470c7c03ba736d35280d41/grip-4.6.1.tar.gz"
  sha256 "a5e6ac48cd253892f0fbd0aaef3f74fe8169d8ed3d94a2e9be6bf1540e008e9f"
  license "MIT"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "74e7de5e68651d60aaa23c3dcc56d318b08819a27fc7c219ae6cf5039646cfbf"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6325c556f0e1f166a85f09b9e9fd17394106dc106051c89383761ceae3a77d8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f7e4920cc4137ef15b11424bb6430a6ad307d3d0eef810970f04587cf5e9d64c"
    sha256 cellar: :any_skip_relocation, ventura:        "78636bc002c323c7fa397e722925a6f414176b89c0d7a2668768b2f06e62f61b"
    sha256 cellar: :any_skip_relocation, monterey:       "26f61644ccdf621c368aba27c024e6265daf02e5aa03c10606406123fb309069"
    sha256 cellar: :any_skip_relocation, big_sur:        "69a18155f319a01d2eb0b074482660e2b41b6f5f34f239a09b69ae0b652415c2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56236e4783a89bf3f68225fe16ca3b73fefa76152ec6340b88ce72e682b75aa3"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "blinker" do
    url "https://files.pythonhosted.org/packages/e8/f9/a05287f3d5c54d20f51a235ace01f50620984bc7ca5ceee781dc645211c5/blinker-1.6.2.tar.gz"
    sha256 "4afd3de66ef3a9f8067559fb7a1cbe555c17dcbe15971b05d1b625c3e7abe213"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "Flask" do
    url "https://files.pythonhosted.org/packages/46/e7/3dc143f22a6aa997753aac1eb68b1b4ac8696819f10ff89d4ebb3de4c42d/Flask-2.3.1.tar.gz"
    sha256 "a6059db4297106e5a64b3215fa16ae641822c1cb97ecb498573549b2478602cb"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "itsdangerous" do
    url "https://files.pythonhosted.org/packages/7f/a1/d3fb83e7a61fa0c0d3d08ad0a94ddbeff3731c05212617dff3a94e097f08/itsdangerous-2.1.2.tar.gz"
    sha256 "5dbbc68b317e5e42f327f9021763545dc3fc3bfe22e6deb96aaf1fc38874156a"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "Markdown" do
    url "https://files.pythonhosted.org/packages/9d/80/cc67bfb7deb973d5ae662ee6454d2dafaa8f7c106feafd0d1572666ebde5/Markdown-3.4.3.tar.gz"
    sha256 "8bf101198e004dc93e84a12a7395e31aac6a9c9942848ae1d99b9d72cf9b3520"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/95/7e/68018b70268fb4a2a605e2be44ab7b4dd7ce7808adae6c5ef32e34f4b55a/MarkupSafe-2.1.2.tar.gz"
    sha256 "abcabc8c2b26036d62d4c746381a6f7cf60aafcc653198ad678306986b09450d"
  end

  resource "path-and-address" do
    url "https://files.pythonhosted.org/packages/2b/b5/749fab14d9e84257f3b0583eedb54e013422b6c240491a4ae48d9ea5e44f/path-and-address-2.0.1.zip"
    sha256 "e96363d982b3a2de8531f4cd5f086b51d0248b58527227d43cf5014d045371b7"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  resource "Werkzeug" do
    url "https://files.pythonhosted.org/packages/ae/66/1b437603a0300864b0fd1e49b732d45a8a5be615eba5121f7cdfb97668dd/Werkzeug-2.3.0.tar.gz"
    sha256 "3b6b46926d052b8ebca97c4dc73c12e47bdd07d57ab0600c039c3155450227bc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "<strong>Homebrew</strong> is awesome",
                 pipe_output("#{bin}/grip - --export -", "**Homebrew** is awesome.")
  end
end
