class Dunamai < Formula
  include Language::Python::Virtualenv

  desc "Dynamic version generation"
  homepage "https://github.com/mtkennerly/dunamai"
  url "https://files.pythonhosted.org/packages/57/f8/5d45804589d3ebeaa259ac8a5d623afcd5d411b7909edf3f03bb0f7c43dd/dunamai-1.16.1.tar.gz"
  sha256 "4f3bc2c5b0f9d83fa9c90b943100273bb087167c90a0519ac66e9e2e0d2a8210"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6c4204d358885f27d6de6ed77fd0336e704a2631e44967f976274d6e6576d08a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9273ab108881fe453076d86ca877cf65f5bad38a03c15705dc926ee871ac7564"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "384c8d969a95427b143d314634187c60ac28ea8bbd0d33722b68d4a6843d481f"
    sha256 cellar: :any_skip_relocation, ventura:        "45fa238049a432348aad737ce70ae745f0ed2687623118cada00806a09128ad5"
    sha256 cellar: :any_skip_relocation, monterey:       "d2055773827aec50e583881261f9c95309454e4de573abf693687b2690fa1358"
    sha256 cellar: :any_skip_relocation, big_sur:        "e616d2f808ffdd3b64ad0f6dfb8e6cf0910fe108f4f86f3f12868e5b6480a9ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d2eb36512553e61968e063640abea85d294713fb74b67a45e8b7dfa88d321c73"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "git", "init"
    system "git", "config", "user.name", "BrewTestBot"
    system "git", "config", "user.email", "BrewTestBot@test.com"
    touch "foo"
    system "git", "add", "foo"
    system "git", "commit", "-m", "bar"
    system "git", "tag", "v0.1"
    assert_equal "0.1", shell_output("#{bin}/dunamai from any").chomp
  end
end
