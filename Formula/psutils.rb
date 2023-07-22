class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/c9/e1/b21d2005f929ee9a8891080dbff70b322566e027e16823a050e72a37baea/pspdfutils-3.0.8.tar.gz"
  sha256 "392392b7eb67848a7f30e7c96e88e0a54bdc95b34dea57df6f3fad303289e40d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1bafba6dd4d2db7a9327970fcb985845ee15aed51510bca9a3c31d1c3662cb61"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5a0bddd52024d74213492e90b1e87d2350ecc72d4db3c48790f4722434245f73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d6f7059dd6bf8d26b6f88b3858848019bceb1485cb5210c386ee3171f4335d9c"
    sha256 cellar: :any_skip_relocation, ventura:        "5b491e3a4ed7d2bf6692f8d0f095e43933ee6a3f2ab596ca9c974d3a9a817361"
    sha256 cellar: :any_skip_relocation, monterey:       "cce9cc324c46f4e94b89116c9e1a3d1e5eab38094585ee55a0bc62bca6f2ff64"
    sha256 cellar: :any_skip_relocation, big_sur:        "f3b8f7b188540b43e3c2495d5d2e92ef6de1137544857212d446ba7d3f2d042e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "36d9f847c3f3e90c30affd7cd510df256f0ef25eaee10a950b5f45b58dc5eab7"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/54/34/0f351758d7285409cc7ec7f7b92cb5201416bf7bfb78461ee1a593e75c74/pypdf-3.12.2.tar.gz"
    sha256 "8657d56fd4f64540b9a1e5285845543534321484f1276af893eead7bd00598e6"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    resource "homebrew-test-ps" do
      url "https://raw.githubusercontent.com/rrthomas/psutils/e00061c21e114d80fbd5073a4509164f3799cc24/tests/test-files/psbook/3/expected.ps"
      sha256 "bf3f1b708c3e6a70d0f28af55b3b511d2528b98c2a1537674439565cecf0aed6"
    end
    resource("homebrew-test-ps").stage testpath

    expected_psbook_output = "[4] [1] [2] [3] \nWrote 4 pages\n"
    assert_equal expected_psbook_output, shell_output("#{bin}/psbook expected.ps book.ps 2>&1")

    expected_psnup_output = "[1,2] [3,4] \nWrote 2 pages\n"
    assert_equal expected_psnup_output, shell_output("#{bin}/psnup -2 expected.ps nup.ps 2>&1")

    expected_psselect_output = "[1] \nWrote 1 pages\n"
    assert_equal expected_psselect_output, shell_output("#{bin}/psselect -p1 expected.ps test2.ps 2>&1")
  end
end
