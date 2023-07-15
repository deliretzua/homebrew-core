class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/26/c6/169a384bfe44de610f5bbc03b3d4cc23a5a64a75be11864a033f2fe195db/virtualenv-20.24.0.tar.gz"
  sha256 "e2a7cef9da880d693b933db7654367754f14e20650dc60e8ee7385571f8593a3"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d5a234f51c61a0e506cf04728396fef80aff46154d7e8b4c1859046171f665e6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1117e3f91c84c2a0dfaa8f9e29b45baace9cb84541aa00f3ea6e59d9645cbc7f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5779bf429fad76eef3380ec73581ff8b32e5f6512e86da472bd38de7be56cf91"
    sha256 cellar: :any_skip_relocation, ventura:        "dc326eb226cfe6cc55e791c5a2fe8342b9fdd7f4cb244c37e5ea295eea9e30e2"
    sha256 cellar: :any_skip_relocation, monterey:       "fdda565f0cc327476e405bca6d5943bcf93c1e0e5a8a323b45738cb4425df732"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ab88f89f1470fcefde5ead7ec708bbe9c028a40a99f4a6cc857209060a0b97d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "61fc80eeaa72f2e3c056f0f58bf6ae4af0f00f054a430aaf3a1142944b44b04e"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/92/38/3dd18a282991c004851ea1f0953105a186cfc691eee2792778ac2ca060f8/platformdirs-3.8.1.tar.gz"
    sha256 "f87ca4fcff7d2b0f81c6a748a77973d7af0f4d526f98f308477c3c436c74d528"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
