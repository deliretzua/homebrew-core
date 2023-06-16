class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/de/96/fd5b083d1517d68721865092b0d86eaeee33150bca4c0ee1bf4d931b8f9f/pipdeptree-2.9.3.tar.gz"
  sha256 "d0049795a78c600bce97663a4d0ae3ebc212f7ccc2f1bd3efef910b7e8bf4591"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7cd81b6f3c196d32224acde1adebf9dbd1225fbc5fc165d63136338b6433eb95"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bdb05278ba5b7b7c3784ebfddf335a2ebf5eb9b68f0aeaf38bf7495b04fba711"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d976f89abf5a20780f106de96b55ac041eb628928768360ed2cd2224e667050c"
    sha256 cellar: :any_skip_relocation, ventura:        "64714f74a1e6db1b578deb7ec6e00611c4a3f477c9bb39558406407e9e3852aa"
    sha256 cellar: :any_skip_relocation, monterey:       "3549242ddd27ec2025cb78642b227f2031d0372ab9aa45915e174bb80043a104"
    sha256 cellar: :any_skip_relocation, big_sur:        "05202cf2b7f0355ba4093c08a692dcbbc19d723a38d2061b09d38b1051448048"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2713db7fede9e65c9dae0a75f6b78af94974631ac97714790f5816e3b2882bd3"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "pipdeptree==#{version}", shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
