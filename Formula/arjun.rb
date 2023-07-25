class Arjun < Formula
  include Language::Python::Virtualenv

  desc "HTTP parameter discovery suite"
  homepage "https://github.com/s0md3v/Arjun"
  url "https://files.pythonhosted.org/packages/51/cd/8eaadf3973a4e7bb519b885588b13348ddbe6d97ca06ecdcdda5f7a53dcb/arjun-2.2.1.tar.gz"
  sha256 "b1904add44c0c5a8241910b0555d7e252281187b7dadd16ebc0843dc768cb36e"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "eab0912e8df26af605a5d6079f291726da405e8472c66e752cb5480130f7df4f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b029ce875cfab6315d492531c977e10364cf656a7dd930cb351071557fa0f41f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4a0d11e1ef26a43e7b6abc61e2c99a30015367b751f95df8932103111d1a706"
    sha256 cellar: :any_skip_relocation, ventura:        "fc358d9f98519f15bda560a380e40584a5de6565e67d03ca1aa46f59f64d4d18"
    sha256 cellar: :any_skip_relocation, monterey:       "60bcbde880f2ca15abe7ca6763db20431d23f6274e381401ba112a15f6f05ddc"
    sha256 cellar: :any_skip_relocation, big_sur:        "241f880c4d24eac04047c94a58943617ed66fc15128ca7f24d2c6320eacbfe45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c50942bb24762798a03c9099b7dbc7d5dbc93f2abc9e68c283d8e3447b67d0ca"
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
    url "https://files.pythonhosted.org/packages/31/ab/46bec149bbd71a4467a3063ac22f4486ecd2ceb70ae8c70d5d8e4c2a7946/urllib3-2.0.4.tar.gz"
    sha256 "8d22f86aae8ef5e410d4f539fde9ce6b2113a001bb4d189e0aed70642d602b11"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = shell_output("#{bin}/arjun -u https://mockbin.org/ -m GET")
    assert_match "No parameters were discovered", output
  end
end
