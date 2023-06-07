class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/24/e1/6487323228477c0f68ea1f853ff78e9909736d209fdc38351d2772ca0346/pipdeptree-2.9.0.tar.gz"
  sha256 "b2e89d19b832f40c19e124a81857c1a4c313cd601e32300ea837ba4797ef9af3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "182d0ceef186cedecc6b1f593d83cc686c27105c2a51cae7a2899066a6044fc5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99243c3c2940bcbdeaaadfd055dccd022f1c2a1b41f4a2774e1add9fab4f220e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bdd94bba512407af15a53aa3de51d0ec700f8669ba5d8d14287416e9ff8869e1"
    sha256 cellar: :any_skip_relocation, ventura:        "ab4c076ebacebde7934b6693d11e4c062b88341f5c6c2910c718f6f8e4480c09"
    sha256 cellar: :any_skip_relocation, monterey:       "4abd386b1c44a8b632b445449f3a364633c91e8e72747920994fef6447cf415a"
    sha256 cellar: :any_skip_relocation, big_sur:        "ff88796a892de450179b073a2dec03e779a75b10455b99d2d28b60249716b7dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a6e5d157425fb1b4abea87bc33c8ba1077c46e1bcbd5c97d4548223746d01e6"
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
