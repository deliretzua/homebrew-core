class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/61/b9/be0db76b6ab3d3b80af727ce502d17069cf9559b920e1cc0076d3ac9a03f/aiven_client-2.20.0.tar.gz"
  sha256 "b15f18afc3526d1facccea02d2f7362b1cd84a9a8a26be3023d972f3904423c5"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f9d325d764e9a770c7e5c8a156419f85b44b14b89c3f31e40b924ad3c67e8e6c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c250fedefe4c182d94e5e69cfaf9d17fbafc5ec06829149396498bee9bb3ee0d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4eedc80e474f0e5be58c833a60d7f3a292a448af8b2766085a52db2da6df5c50"
    sha256 cellar: :any_skip_relocation, ventura:        "07a5a30b8906985b8527b9233da5cd1bbadf2a07bdcd3c43e5f4f19d6d88c4df"
    sha256 cellar: :any_skip_relocation, monterey:       "f4ce396c2d85fbe99f510c476b1c8cb3b50532c1e350b31a0528c47e88566f32"
    sha256 cellar: :any_skip_relocation, big_sur:        "b6dd6056dd3700bbdfa684e4d93c242c5953f225fb5cafd2c3caf4acabe70305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d358234694ac4b4305698df1e8c168159248b36119b9c0b7e64f82cb81064d0c"
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
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end
