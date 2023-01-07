class Pipgrip < Formula
  include Language::Python::Virtualenv

  desc "Lightweight pip dependency resolver"
  homepage "https://github.com/ddelange/pipgrip"
  url "https://files.pythonhosted.org/packages/69/c7/dd8261bcc99eff40a63043ff461b46ed43d08f14f873b7b450e460802679/pipgrip-0.10.2.tar.gz"
  sha256 "2a6116e2794357f5f4420c1282c2e7a37f0bc8c571b6af90ee6a8ea1f89c7461"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4a975c3d45bf11765a18c7595b802fd6cec0d4f095aecc3ce5c1315bcd1d63f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "90a118996aaa01140969b8c1af5efa7e446e464fd28daed5c50b5dd98903fe7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3b08ca0a80dec0a22b9499aacbbd35ff696a58c289305302454ab0bd5873b37c"
    sha256 cellar: :any_skip_relocation, ventura:        "15d2e7b155c23568fd0c3118db80b54b041cf45670a41e2fa160b858674e3254"
    sha256 cellar: :any_skip_relocation, monterey:       "919c1bbb603ee4ff9c7acef416d32ca042a7ad256a897191c187ae9133f4f658"
    sha256 cellar: :any_skip_relocation, big_sur:        "e39601ac8d5bf63010b49b01be3b116724c70156c98809ab47a07a4d680a56a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a59434e8d8cd7cce5708a9420ccf358ed566ac63dc5e068ba6a579edfc0f80d4"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "anytree" do
    url "https://files.pythonhosted.org/packages/d8/45/de59861abc8cb66e9e95c02b214be4d52900aa92ce34241a957dcf1d569d/anytree-2.8.0.tar.gz"
    sha256 "3f0f93f355a91bc3e6245319bf4c1d50e3416cc7a35cc1133c1ff38306bbccab"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/6b/f7/c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65/packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
  end

  resource "pkginfo" do
    url "https://files.pythonhosted.org/packages/23/3f/f2251c754073cda0f00043a707cba7db103654722a9afed965240a0b2b43/pkginfo-1.7.1.tar.gz"
    sha256 "e7432f81d08adec7297633191bbf0bd47faf13cd8724c3a13250e51d542635bd"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/a2/b8/6a06ff0f13a00fc3c3e7d222a995526cbca26c1ad107691b6b1badbbabf1/wheel-0.38.4.tar.gz"
    sha256 "965f5259b566725405b05e7cf774052044b1ed30119b5d586b2703aafe8719ac"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipgrip==#{version}", shell_output("#{bin}/pipgrip pipgrip --no-cache-dir")
    # Test gcc dependency
    assert_match "dxpy==", shell_output("#{bin}/pipgrip dxpy --no-cache-dir")
  end
end
