class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/e9/2a/b2c6217d94aea5024614be2e6b13ce426596c8cb26c67206085f0f000ec2/yubikey_manager-5.1.0.tar.gz"
  sha256 "d33efc9f82e511fd4d7c9397f6c40b37c7260221ca06fac93daeb4a46b1eb173"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "c6a3e121cdba5f024b645f341e14aaec753b454cd3a003839de177d78c26de40"
    sha256 cellar: :any,                 arm64_monterey: "7f8c9a093fc951b99114d332ceb25385298fbd1248a34ed96b63013026031682"
    sha256 cellar: :any,                 arm64_big_sur:  "ed416b97ceeeb04521e5c6d365c3eec35933c472f3301598d433778661b41d42"
    sha256 cellar: :any,                 ventura:        "b020ce89d8dc4f0e1c5e07e7ad72fe900f2329afca1cc445bbe750b626bea746"
    sha256 cellar: :any,                 monterey:       "917a5521e62d81b2d0380b282d0505634f03fa7da74329f67ddaf897fc98630d"
    sha256 cellar: :any,                 big_sur:        "a6942371ce9f176a298ea68f8c56da8b24a1380ff2d3d0c63e804515d66f52e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cdfd2e70e761faf8cecde3e80b67009432239c007d42a671a2238c9722fde113"
  end

  # `pkg-config` and `rust` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pcsc-lite"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f7/80/04cc7637238b78f8e7354900817135c5a23cf66dfb3f3a216c6d630d6833/cryptography-40.0.2.tar.gz"
    sha256 "c33c0d32b8594fa647d2e01dbccc303478e16fdd7cf98652d5b3ed11aa5e5c99"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/5a/67/244ad51cb9fd87eaf8797820d95e79d6d5f940c0aafe931e8051b60dd8a0/fido2-1.1.1.tar.gz"
    sha256 "5dc495ca8c59c1c337383b4b8c314d46b92d5c6fc650e71984c6d7f954079fc3"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/20/fc/a0e728307f38609ef849d813c95dc974d344a3d395f62013ddcd8fbe0bfe/importlib_metadata-6.4.1.tar.gz"
    sha256 "eb1a7933041f0f85c94cd130258df3fb0dec060ad8c1c9318892ef4192c47ce1"
  end

  resource "jaraco.classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/55/fe/282f4c205add8e8bb3a1635cbbac59d6def2e0891b145aa553a0e40dd2d0/keyring-23.13.1.tar.gz"
    sha256 "ba2e15a9b35e21908d0aaf4e0a47acc52d6ae33444df0da2b49d41a46ef6d678"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2e/d0/bea165535891bd1dcb5152263603e902c0ec1f4c9a2e152cc4adff6b3a38/more-itertools-9.1.0.tar.gz"
    sha256 "cabaa341ad0389ea83c17a94566a53ae4c9d07349861ecb14dc6d0345cf9ac5d"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/cc/33/b7d115ccf1b594af18db7ca61a7b07192356be35c65dfcd1d5ef9b28dc0a/pyscard-2.0.7.tar.gz"
    sha256 "278054525fa75fbe8b10460d87edcd03a70ad94d688b11345e4739987f85c1bf"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC" if OS.linux?

    virtualenv_install_with_resources
    man1.install "man/ykman.1"

    # Click doesn't support generating completions for Bash versions older than 4.4
    generate_completions_from_executable(bin/"ykman", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
