class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/65/57/65ec78caae76c9ac86f756478a534543bbb4a403e60934aa13f5b2c44cbf/pspdfutils-3.0.4.tar.gz"
  sha256 "2a271854be5d3af7d990492e35ea091972ce4bc06ff9d3814fef49d537d77893"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8831a0973b1914fb78308ed2a278aadd8a62132ffd04dd9e3e626baf56511459"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "94c8710f6399b4271261f79d3105b033abe538baf00646718d8fd1e9ee74db00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "568bc8d0bf2bf828c5974571592d524828f4018ea35a4deffe692dffbd88aba4"
    sha256 cellar: :any_skip_relocation, ventura:        "bef036cfed1d1e339891325a4d97f6cc9a0c610f6ff66061a115de615fae0895"
    sha256 cellar: :any_skip_relocation, monterey:       "6ede47ada8feff822480aafad739e04a0da10ab7f1f9e79636083d1fd941d272"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d5cd50502f83e2be7c674abcb2d0e9e7230f17f002b72332bba0bbc557ea7a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea826a977df9d4a277b452bb5a2bce7542ad15e8708d7b4305ce354f6af1407a"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/84/46/50c317477ccd23979b7e18847d2c58c8fca89b0db41670bc819710aab26a/pypdf-3.9.1.tar.gz"
    sha256 "c2b7fcfe25fbd04e8da600cb2700267ecee7e8781dc798cce3a4f567143a4df1"
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
