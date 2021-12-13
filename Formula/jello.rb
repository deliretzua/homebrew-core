class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/fe/98/558adcfc12ae91fbfdb20f88547877dd02d485a378c15602822d52263fcf/jello-1.5.1.tar.gz"
  sha256 "2d5cd7655bcb887b31afe5da4e7d13ffa4565da9ca0c36d90f7c2c0eacf060a0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cc7577329e126498a9a2acad850c6f0645b883d4e7aeb20257629f5e5574a408"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cc7577329e126498a9a2acad850c6f0645b883d4e7aeb20257629f5e5574a408"
    sha256 cellar: :any_skip_relocation, monterey:       "6430ab8e4a441716261b3594867efd77d767640564ec77eb5e5ff07486b95f08"
    sha256 cellar: :any_skip_relocation, big_sur:        "6430ab8e4a441716261b3594867efd77d767640564ec77eb5e5ff07486b95f08"
    sha256 cellar: :any_skip_relocation, catalina:       "6430ab8e4a441716261b3594867efd77d767640564ec77eb5e5ff07486b95f08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "74aa44e77eed05e2edce3a3026dfcf7cfc421f4c939560d98d61d6cd63144b97"
  end

  depends_on "python@3.10"

  resource "Pygments" do
    url "https://files.pythonhosted.org/packages/b7/b3/5cba26637fe43500d4568d0ee7b7362de1fb29c0e158d50b4b69e9a40422/Pygments-2.10.0.tar.gz"
    sha256 "f398865f7eb6874156579fdf36bc840a03cab64d1cde9e93d68f46a425ec52c6"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
