class Osc < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to work with an Open Build Service"
  homepage "https://openbuildservice.org"
  url "https://github.com/openSUSE/osc/archive/1.2.0.tar.gz"
  sha256 "0b2b094a515b340f859b417016def33f9b33a47abe4c3fad66c5dbc8b8447a7d"
  license "GPL-2.0-or-later"
  head "https://github.com/openSUSE/osc.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "17972241c9dbd00b619bbc0e0e595525b30b170f653a4b8dc43d4ff5e38672cb"
    sha256 cellar: :any,                 arm64_monterey: "b4f05310448c2be7183062ee6d174924ca3fd8ebf0bafbef8dd04ce9488a3cb9"
    sha256 cellar: :any,                 arm64_big_sur:  "8f8c7cb826990dbb63ec67ea4243243928618e7f0cb43605163ead667131dcf6"
    sha256 cellar: :any,                 ventura:        "f9d5ac6c9d0f8f76a00c292d170b8b3c3a8e2489fed95263630a9950d5d044f2"
    sha256 cellar: :any,                 monterey:       "ef31f868a24ae2c9b20879693782af599d81bcbf461949f2d9e3fb44332c2895"
    sha256 cellar: :any,                 big_sur:        "76c7326b5cec95c1b94349a997a350c45bc503afa1d68c25330bb46d3aee91b6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ea82dec671ead769b0f867cab239a6ace5d0b5fde31ffb0f1ef17a785b8ca90"
  end

  # `pkg-config` and `rust` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@3"
  depends_on "pycparser"
  depends_on "python@3.11"

  uses_from_macos "curl"

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/93/b7/b6b3420a2f027c1067f712eb3aea8653f8ca7490f183f9917879c447139b/cryptography-41.0.2.tar.gz"
    sha256 "7d230bf856164de164ecb615ccc14c7fc6de6906ddd5b491f3af90d3514c925c"
  end

  resource "rpm" do
    url "https://files.pythonhosted.org/packages/8c/15/ef9b3d4a0b4b9afe62fd2be374003643ea03fc8026930646ad0781bb9492/rpm-0.1.0.tar.gz"
    sha256 "0e320a806fb61c3980c0cd0c5f5faec97c73c347432902ba2955a08a7b1a034f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/d6/af/3b4cfedd46b3addab52e84a71ab26518272c23c77116de3c61ead54af903/urllib3-2.0.3.tar.gz"
    sha256 "bee28b5e56addb8226c96f7f13ac28cb4c301dd5ea8a6ca179c0b9835e032825"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
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
