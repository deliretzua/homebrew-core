class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/d4/85/cf96c822d14517b65bed9928c594cfb9d87b5eafe42ffe45d4ef39f21093/aiven_client-2.19.0.tar.gz"
  sha256 "167dc3da4e52de0de22fa088baaf025360f68d3aaff26155b55e7f16e46c791f"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce354e85c6f7f6d1de5370ff5c2f4002a33745a61c0698c347693c4d50087b9e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b37d5dfa7d3763ffcf1ef8b11c0ce69ca4269737ca0a8121bae19292b7bcbc94"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dd9e293b9dd3d2c482642b7dacd41fa4509ebe674fb06242f5a51767dd76ba29"
    sha256 cellar: :any_skip_relocation, ventura:        "be7b7aed8f3db4a8503b7ec21ca6f96e5e19b23788d5f26700ef44db4f126f5f"
    sha256 cellar: :any_skip_relocation, monterey:       "6d72e266b15812c48f951673224c4f2ef90370f0a98cc6dc00476e362366363f"
    sha256 cellar: :any_skip_relocation, big_sur:        "91d7c373fb675d2d8c74a9416a5eb3deb69299f6fd3eb786a2bfebcaf1eaadee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "13d9062d25342099f1f87ab92c85e1b0c899c6f3b7be09997ae506c68f5d6e03"
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
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end
