class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "🐸 Identify anything: emails, IP addresses, and more 🧙"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/a0/c3/681e4db7fedb660f8ad05017aea7d970aaf32090e3b7976622036fb7881e/pywhat-4.0.0.tar.gz"
  sha256 "8fc5ef7c3a343f0baf690a34e97eeb9223ca74613017125273f4bd759e141d90"
  license "MIT"
  head "https://github.com/bee-san/pyWhat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd211373dc4abf05111b47598a523831790be1813c544cf1c5544fa66836f922"
    sha256 cellar: :any_skip_relocation, big_sur:       "2ac4b341484a39263e02deb6db93942fa23d96285b5cdc3f20399e3f38393d4c"
    sha256 cellar: :any_skip_relocation, catalina:      "1558c75a69c1f7cc823ea2a1223504e376f6492763e4fb3adc9e64ae30c8f298"
    sha256 cellar: :any_skip_relocation, mojave:        "921d314d889ca546e6ade00402a0b8e2dff85df978c3843b723c2b0a6f12b68c"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "commonmark" do
    url "https://files.pythonhosted.org/packages/60/48/a60f593447e8f0894ebb7f6e6c1f25dafc5e89c5879fdc9360ae93ff83f0/commonmark-0.9.1.tar.gz"
    sha256 "452f9dc859be7f06631ddcb328b6919c67984aca654e5fefb3914d54691aed60"
  end

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  resource "rich" do
    url "https://files.pythonhosted.org/packages/57/3f/a8ba181148dcb9184cb0afac66d075fce60f06f926ce9cdab3dc61fd6497/rich-10.11.0.tar.gz"
    sha256 "016fa105f34b69c434e7f908bb5bd7fefa9616efdb218a2917117683a6394ce5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/pywhat 127.0.0.1").strip
  end
end
