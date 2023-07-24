class AivenClient < Formula
  include Language::Python::Virtualenv

  desc "Official command-line client for Aiven"
  homepage "https://docs.aiven.io/docs/tools/cli"
  url "https://files.pythonhosted.org/packages/46/b5/38fca92bce202f6c547d709743545eba881cadfe495903d234149f6d360c/aiven_client-3.0.0.tar.gz"
  sha256 "9690d64da1e9306d2308f3f125f347acd6b53db4e7927ef4a7d4c0d1cd2b1b6c"
  license "Apache-2.0"
  head "https://github.com/aiven/aiven-client.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64c0901e161dd97809caf3cd84cea98bf228b7e240162be415a20e4257f17057"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c490f5dd9847bf700ec550bea2dd3fbecc48b01b00a1cf22dfb0f29f1a83e5f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d82af0ee56d649af5baf54a51d99819f2dae9d3f62e29600e9ef14918673dd63"
    sha256 cellar: :any_skip_relocation, ventura:        "e58cc947f0a520eb7e12f3575a693b81193ed6115b248d3248ba84bcdba977a6"
    sha256 cellar: :any_skip_relocation, monterey:       "8caab728f33bfbae539b084bbd7dc17a36a9b48757800a34cfba31b15c7c99b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a2ca178c84c2b6285e845e121243f656d37104e8d0749a605e89a27eea3aa65"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27020f245ec2da7c355d00ab48d57c0e2961684d0f30a125e23867dbe46748be"
  end

  depends_on "python@3.11"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/98/98/c2ff18671db109c9f10ed27f5ef610ae05b73bd876664139cf95bd1429aa/certifi-2023.7.22.tar.gz"
    sha256 "539cc1d13202e33ca466e88b2807e29f4c13049d6d87031a3c110744495cb082"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/2a/53/cf0a48de1bdcf6ff6e1c9a023f5f523dfe303e4024f216feac64b6eb7f67/charset-normalizer-3.2.0.tar.gz"
    sha256 "3bb3d25a8e6c0aedd251753a79ae98a093c7e7b471faa3aa9a93a81431987ace"
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
    assert_match "aiven-client", shell_output("#{bin}/avn --version")
    assert_match "UserError: not authenticated", pipe_output("AIVEN_CONFIG_DIR=/tmp #{bin}/avn user info 2>&1")
  end
end
