class DetectSecrets < Formula
  include Language::Python::Virtualenv

  desc "Enterprise friendly way of detecting and preventing secrets in code"
  homepage "https://github.com/Yelp/detect-secrets"
  url "https://files.pythonhosted.org/packages/f1/55/292f9ce52bba7f3df0a9cde65dabf458d3aeec6a63bf737e5a5fa9fe6d31/detect_secrets-1.4.0.tar.gz"
  sha256 "d56787e339758cef48c9ccd6692f7a094b9963c979c9813580b0169e41132833"
  license "Apache-2.0"
  head "https://github.com/Yelp/detect-secrets.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c6177e1d8bc674be4ab6b73c7e9643efcc2e70f10ac5e3dbc245327efe13d09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b387eaa1e377705fd5c010d7b88b754d95932dbc935c74df1215870c8fa7135a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54520e1021ad0f40eee0904d4e85d24b4b5898c16386d6be6c794667a006db0d"
    sha256 cellar: :any_skip_relocation, ventura:        "4e4df008031d270b25826dae5ee64bb2cfabf391d1e14d880d54c225690b8989"
    sha256 cellar: :any_skip_relocation, monterey:       "52816f078e0e8f5c254148bb9b41040cdb4d800e1194ee31e31828e5aedbcbff"
    sha256 cellar: :any_skip_relocation, big_sur:        "b960952cd63ec5589e2e1da1fb0bd8960455e0db7b532385aaae632c1c44ca97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "425076b4ff0e2f81bf11a87138b62077db7f5bf549072431185122dd0e7bc254"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
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
    assert_match "ArtifactoryDetector", shell_output("#{bin}/detect-secrets scan --list-all-plugins 2>&1")
  end
end
