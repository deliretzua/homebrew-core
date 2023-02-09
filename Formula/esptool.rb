class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://github.com/espressif/esptool"
  url "https://files.pythonhosted.org/packages/8b/4c/82d7fe5fa0643415bbb90bebff1f861816903c481ee5156fabd6d76dc684/esptool-4.4.tar.gz"
  sha256 "8acd4dfe70819b1302861ae92894380fb4700b377f5a4739479a4ec276e0b256"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "f4f3ca5a13ef6bb4440a9568897ba16aea9f3ca5ef3715fbfbe2d1790383a473"
    sha256 cellar: :any,                 arm64_monterey: "54267a72542328c0c0a9eb8630b0d9f9b21ed6f2e6020888eae0f1f862d2c764"
    sha256 cellar: :any,                 arm64_big_sur:  "9ed5be17fb51960b545bad3c1bf8c84c9043b5a83a865ac4ac82b9f8a4883884"
    sha256 cellar: :any,                 ventura:        "20345550e343743ea284630b99027147a3541e5971213f60af39476ae91621a3"
    sha256 cellar: :any,                 monterey:       "ee3162f847fb4c3997f84ce927212c50af07953b2d855406990620e635bae3eb"
    sha256 cellar: :any,                 big_sur:        "005e9a142d37e83d71039c44b204cc1df0bccb83ac65ca59d33d6a4872e80952"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8f3a339a549817036cfa18c2c0d645ed10cdc508feeaf8697f2cdb6b20a7585c"
  end

  depends_on "rust" => :build
  depends_on "python@3.11"
  depends_on "six"

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/4c/b1/80d58eeb21c9d4ca739770558d61f6adacb13aa4908f4f55e0974cbd25ee/bitstring-3.1.9.tar.gz"
    sha256 "a5848a3f63111785224dca8bb4c0a75b62ecdef56a042c8d6be74b16f7e860e7"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/6a/f5/a729774d087e50fffd1438b3877a91e9281294f985bda0fd15bf99016c78/cryptography-39.0.1.tar.gz"
    sha256 "d1f6198ee6d9148405e49887803907fe8962a23e6c6f83ea7d98f1c0de375695"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/c8/cb/bb2ddbd00c9b4215dd57a2abf7042b0ae222b44522c5eb664a8fd9d786da/reedsolo-1.5.4.tar.gz"
    sha256 "b8b25cdc83478ccb06361a0e8fadc27b376a3dfabbb1dc6bb583a998a22c0127"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    require "base64"

    assert_match version.to_s, shell_output("#{bin}/esptool.py version")
    assert_match "usage: espefuse.py", shell_output("#{bin}/espefuse.py --help")
    assert_match version.to_s, shell_output("#{bin}/espsecure.py --help")

    (testpath/"helloworld-esp8266.bin").write ::Base64.decode64 <<~EOS
      6QIAICyAEEAAgBBAMAAAAFDDAAAAgP4/zC4AQMwkAEAh/P8SwfAJMQH8/8AAACH5/wH6/8AAAAb//wAABvj/AACA/j8QAAAASGVsbG8gd29ybGQhCgAAAAAAAAAAAAAD
    EOS

    result = shell_output("#{bin}/esptool.py --chip esp8266 image_info #{testpath}/helloworld-esp8266.bin")
    assert_match "4010802c", result
  end
end
