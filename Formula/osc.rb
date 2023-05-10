class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/1.1.3.tar.gz"
  sha256 "bf390a6b6e532ce02bc009368f21212748fa64313d9caee3d3d3f2cbdc55b3c8"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "84e3a32134e358f86ae636c45fde42018d5a6027e5a066ae28d616c2e19c06c7"
    sha256 cellar: :any,                 arm64_monterey: "932b6eaa38733e4feb382b028011284163334e9563ea195eb676490728ec685c"
    sha256 cellar: :any,                 arm64_big_sur:  "c3e83683352cb69fcf93ea2bfeba016eb20f712fbad58b187f8254f06d844a1a"
    sha256 cellar: :any,                 ventura:        "56dc534a6ffd985c18d3ac876a9a4ddcffe8e34810d686ec2d02d1b83ee085c1"
    sha256 cellar: :any,                 monterey:       "f3ef081a1926a4d68afdbc7fedf686627be653953e8914ce5dde3ff98901a8f6"
    sha256 cellar: :any,                 big_sur:        "ed260330d06c9e70ce1da47d3856a3d18528889bbd0ecde6ef53098e01b08ba2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b15e607959e0d6ed2e96da2c2043c5f10bb95d4d4cfb1987b42311b94dc883dc"
  end

  # `pkg-config` and `rust` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f7/80/04cc7637238b78f8e7354900817135c5a23cf66dfb3f3a216c6d630d6833/cryptography-40.0.2.tar.gz"
    sha256 "c33c0d32b8594fa647d2e01dbccc303478e16fdd7cf98652d5b3ed11aa5e5c99"
  end

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    virtualenv_install_with_resources
  end

  test do
    test_config = testpath/"oscrc"
    ENV["OSC_CONFIG"] = test_config

    test_config.write <<~EOS
      [general]
      apiurl = https://api.opensuse.org

      [https://api.opensuse.org]
      credentials_mgr_class=osc.credentials.TransientCredentialsManager
      user=brewtest
      pass=
    EOS

    output = shell_output("#{bin}/osc status 2>&1", 1).chomp
    assert_match "Directory '.' is not a working copy", output
    assert_match "Please specify a command", shell_output("#{bin}/osc 2>&1", 2)
  end
end
