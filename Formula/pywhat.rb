class Pywhat < Formula
  include Language::Python::Virtualenv

  desc "🐸 Identify anything: emails, IP addresses, and more 🧙"
  homepage "https://github.com/bee-san/pyWhat"
  url "https://files.pythonhosted.org/packages/25/9c/a378d4ad8727a19bc0f4e2cb7ff80605388e8260e64ddaf705b0bac5b0be/pywhat-4.3.0.tar.gz"
  sha256 "8106f18be8ebd42185231ae0e336412ba04cb031b14961fea74348a15e0b8abc"
  license "MIT"
  head "https://github.com/bee-san/pyWhat.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c8b90b0ea0a7d0dde5d6b83a75fab5cce35541069ee1fee59237c1d2cb0a6fbc"
    sha256 cellar: :any_skip_relocation, big_sur:       "61590ef5f88101a49a0ad8949c8802859c0c039e916360c8bd0276f7304dd3e8"
    sha256 cellar: :any_skip_relocation, catalina:      "8301e11f7a275af316ecc87bdc40fc498f9c1322a9fe3a5544e515bf74d741a5"
    sha256 cellar: :any_skip_relocation, mojave:        "c5d70a060f16418e613fd763b8d28b22c87a3e503b37429b6099c7a773a62736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78e9d48549f7cd9a01c35f7583b49e1ba94dc55b2945c48c465275dbde8b91c5"
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
    url "https://files.pythonhosted.org/packages/4e/fd/5d40b0363467f8c87d5f5f551b7b431e234bff2becf959daab453f9d7795/rich-10.12.0.tar.gz"
    sha256 "83fb3eff778beec3c55201455c17cccde1ccdf66d5b4dade8ef28f56b50c4bd4"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "Internet Protocol (IP)", shell_output("#{bin}/pywhat 127.0.0.1").strip
  end
end
