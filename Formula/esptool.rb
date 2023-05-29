class Esptool < Formula
  include Language::Python::Virtualenv

  desc "ESP8266 and ESP32 serial bootloader utility"
  homepage "https://docs.espressif.com/projects/esptool/en/latest/esp32/"
  url "https://files.pythonhosted.org/packages/04/80/8eb97d1793cfaf830a4c0a7ea1d8f0674ccba8c23b7d02dcce074b5f44ea/esptool-4.5.1.tar.gz"
  sha256 "e3eb59836123e5ebf793ef639311f7d85645526487d8b1c2b51159b455106b9a"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1dab219df9238fe198ba107ba322ef69c9cfb3f79b8cdbc20d119ab3a67347b1"
    sha256 cellar: :any,                 arm64_monterey: "9dc3109ba3f9fdd1a37f46cc0b43b5ee6202dd265fe2beebcf3672b6a3cbe9b4"
    sha256 cellar: :any,                 arm64_big_sur:  "b90fa538f945ac31dcfd85a467fba0742665b52fc34a34437ea83c6ace2b94a2"
    sha256 cellar: :any,                 ventura:        "60f2803b784b668872d20ca95035cbd56b5bc41dda9e2e3729e1c47c3f83d7dc"
    sha256 cellar: :any,                 monterey:       "0c66d2df293f340feeef204bf756e2bab76f159369ceb4a2a95f6a0a54cd8d4c"
    sha256 cellar: :any,                 big_sur:        "63bf386b0e1186dd109da9ad3ebbf3ee1a8ce8a0f325496a2f469545d7b71b30"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36ebd1053d6bd9e40b7d518970c5eb3da6fbb330e9530be81de02f3117cda416"
  end

  # `pkg-config`, `rust`, and `openssl@1.1` are for cryptography.
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "cffi"
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python@3.11"
  depends_on "six"

  resource "bitstring" do
    url "https://files.pythonhosted.org/packages/b5/f1/f55f568ef587fe7a74f46a9ae869dbbda10575b2a404c831d2bc0567b7de/bitstring-4.0.2.tar.gz"
    sha256 "a391db8828ac4485dd5ce72c80b27ebac3e7b989631359959e310cd9729723b2"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/f7/80/04cc7637238b78f8e7354900817135c5a23cf66dfb3f3a216c6d630d6833/cryptography-40.0.2.tar.gz"
    sha256 "c33c0d32b8594fa647d2e01dbccc303478e16fdd7cf98652d5b3ed11aa5e5c99"
  end

  resource "ecdsa" do
    url "https://files.pythonhosted.org/packages/ff/7b/ba6547a76c468a0d22de93e89ae60d9561ec911f59532907e72b0d8bc0f1/ecdsa-0.18.0.tar.gz"
    sha256 "190348041559e21b22a1d65cee485282ca11a6f81d503fddb84d5017e9ed1e49"
  end

  resource "pyserial" do
    url "https://files.pythonhosted.org/packages/1e/7d/ae3f0a63f41e4d2f6cb66a5b57197850f919f59e558159a4dd3a818f5082/pyserial-3.5.tar.gz"
    sha256 "3c77e014170dfffbd816e6ffc205e9842efb10be9f58ec16d3e8675b4925cddb"
  end

  resource "reedsolo" do
    url "https://files.pythonhosted.org/packages/9b/10/28d1492cc82a103bc06f18cb9a9dbb3a9168ab2e4068801fa0aa0c76b231/reedsolo-1.6.0.tar.gz"
    sha256 "4e290d3b0a7207ac7aac186790766c752b5fcdf5e0b04dfd260349579052bbac"
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
