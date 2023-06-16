class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/21/6b/0910aebe4d5c2a27d5a79ab8fae06d22f7e01dff46baf29ced8d080134c3/virtualenv-20.23.1.tar.gz"
  sha256 "8ff19a38c1021c742148edc4f81cb43d7f8c6816d2ede2ab72af5b84c749ade1"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ef550c9f63eb3a337ba64c12690a17db6a93696afd97e3013c2ddcccb842444e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "bcd8ebd290416b607115307adac76018a79b21e6b39aec7aaace681a623c0176"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f803cafcce59e447e90f1e5610b9d0a47ab07768ef69e4cf2dd47ff68dd1b55b"
    sha256 cellar: :any_skip_relocation, ventura:        "e65c19280f0b5b789f4b01e373b47e9b3963d84572cb4ff489b45da952cb348e"
    sha256 cellar: :any_skip_relocation, monterey:       "f998b93c768551d582a4fb6d676b58b03791bbad5ba760937a2c72ebe7d37679"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb80e2e5a44c751529025f76e720e5750c934e17bfb3b692f1a67d9e823ccdc3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f77c60455211f78535f7a87eb374b5010e52f5701f35af4e71b85ca19c02b5ef"
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
    url "https://files.pythonhosted.org/packages/d2/5d/29eed8861e07378ef46e956650615a9677f8f48df7911674f923236ced2b/platformdirs-3.5.3.tar.gz"
    sha256 "e48fabd87db8f3a7df7150a4a5ea22c546ee8bc39bc2473244730d4b56d2cc4e"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
