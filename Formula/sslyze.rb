class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  license "AGPL-3.0-only"

  stable do
    url "https://files.pythonhosted.org/packages/b7/1b/dcf21b1f6b2bd3a0a5bafa7de91a5807cda93b8ceec9dbb593267966f099/sslyze-5.0.3.tar.gz"
    sha256 "258cca18f6b01ab4419acc356a73e1443fe24174e0fd9b7b46448d823a5c7dc0"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/4.0.2.tar.gz"
      sha256 "440296e07ee021dc283bfe7b810f3139349e26445bc21b5e05820808e15186a2"
      # patch is needed until https://github.com/nabla-c0d3/nassl/pull/89 is merged
      patch do
        url "https://github.com/nabla-c0d3/nassl/commit/f210a0d15d65c6ec11f43d3fef9f6004549bf19a.patch?full_index=1"
        sha256 "270d5a76c8753afa318cd3fa0d53fe29f89786cba57096e384697acc1259552d"
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 monterey:     "3c669d78e696b79eb1fc3f4773e23f16697303dcd4cd654d3cdc6650a8894ea7"
    sha256 cellar: :any,                 big_sur:      "123e47b23c6e77da43e30186ab6b18869d4f2b163d9f4f785db8f774800b1dc5"
    sha256 cellar: :any,                 catalina:     "527edd3733f6b7ed3643f8929318a746b5ac28c5000ac0e19d0706e9bc01ce5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "69f556a849cae8daee06e63da570f888204a59d21fae3967be42d2679aadcb5c"
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git", branch: "release"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git", branch: "release"
    end
  end

  depends_on "pyinvoke" => :build
  depends_on "rust" => :build # for cryptography
  depends_on "libffi"
  depends_on "openssl@1.1"
  depends_on "python@3.10"

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/00/9e/92de7e1217ccc3d5f352ba21e52398372525765b2e0c4530e6eb2ba9282a/cffi-1.15.0.tar.gz"
    sha256 "920f0d66a896c2d99f0adbb391f990a84091179542c205fa53ce5787aff87954"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/10/a7/51953e73828deef2b58ba1604de9167843ee9cd4185d8aaffcb45dd1932d/cryptography-36.0.2.tar.gz"
    sha256 "70f8f4f7bb2ac9f340655cbac89d68c527af5bb4387522a8413e841e3e6628c9"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/60/a3/23a8a9378ff06853bda6527a39fe317b088d760adf41cf70fc0f6110e485/pydantic-1.9.0.tar.gz"
    sha256 "742645059757a56ecd886faf4ed2441b9c0cd406079c2b4bee51bcc3fbcd510a"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/12/fc/282d5dd9e90d3263e759b0dfddd63f8e69760617a56b49ea4882f40a5fc5/tls_parser-2.0.0.tar.gz"
    sha256 "3beccf892b0b18f55f7a9a48e3defecd1abe4674001348104823ff42f4cbc06b"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/b1/5a/8b5fbb891ef3f81fc923bf3cb4a578c0abf9471eb50ce0f51c74212182ab/typing_extensions-4.1.1.tar.gz"
    sha256 "1a9462dcc3347a79b1f1c0271fbe79e844580bb598bafa1ed208b94da3cdcd42"
  end

  def install
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources.reject { |r| r.name == "nassl" }

    ENV.prepend_path "PATH", Formula["python@3.10"].opt_libexec/"bin"
    resource("nassl").stage do
      system "invoke", "build.all"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCANS COMPLETED", shell_output("#{bin}/sslyze --mozilla_config=old google.com")
    refute_match("exception", shell_output("#{bin}/sslyze --certinfo letsencrypt.org"))
  end
end
