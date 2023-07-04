class Psutils < Formula
  include Language::Python::Virtualenv

  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://files.pythonhosted.org/packages/30/70/f1f0f2744ac0a7a0fad4bee698ef903278080afffdab6c557cf247fa2924/pspdfutils-3.0.6.tar.gz"
  sha256 "06501dac26044eaafe40fb550281f057b59f3ab565f75dcb9d0590184d3416fc"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "64515b1055b7d26815955832107f47ee1506ce213661ab13941ade76aebc655a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d4fbc2712d3f9b8e1efd50adb7f546d505f7471181ba9c761693266ffad6c025"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70c1f55be883bcba43d362d23fc1b6e22d0cc64b6af0a8f18a1edf4cb0a8f216"
    sha256 cellar: :any_skip_relocation, ventura:        "5e6d262306656a25dfb63ac6e09d50f647e82fc09a911b1a87263aab66ce6a2c"
    sha256 cellar: :any_skip_relocation, monterey:       "1fbdf1c2b1a5be3092d68fc79ee83fe47525a47b4ffb209f243185a78f35cf0b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c4a64fc5e2adee4af646035d07b43831138484f6111338ff36c54ffd68f16be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24ef040b916f7e8c9a8a65ef2c8790945cd4098ae0143f2c4c4fe0109224035b"
  end

  depends_on "libpaper"
  depends_on "python@3.11"

  resource "puremagic" do
    url "https://files.pythonhosted.org/packages/50/bb/c9860ce714ce2147b6168fdf817e67c3be6eabc822fab5ef41cc52bafdec/puremagic-1.15.tar.gz"
    sha256 "6e46aa78113a466abc9f69e6e8a4ce90eb57d908dafb809597012621061462bd"
  end

  resource "pypdf" do
    url "https://files.pythonhosted.org/packages/8a/c6/83cce3fed4c14d0c0f96fd938430516f9371f96fa5801d59d1ba007c8fd8/pypdf-3.12.0.tar.gz"
    sha256 "cebac920db0698369f49c389018858a5436862bf3c45b64b10c55c008878db95"
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
