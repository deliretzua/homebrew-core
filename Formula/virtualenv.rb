class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/d6/37/3ff25b2ad0d51cfd752dc68ee0ad4387f058a5ceba4d89b47ac478de3f59/virtualenv-20.23.0.tar.gz"
  sha256 "a85caa554ced0c0afbd0d638e7e2d7b5f92d23478d05d17a76daeac8f279f924"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "424280b7316871d970df84deeb33b91d7f67900488b85443aa5a9efaf89f95d1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84f672ada6a524d3c38fe558334a4a7a35c76d22dfb90c66448179b135788e60"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "059901c183c6ea8a0ba8772cf0b1a86def562ec52af35c85ec566e4c2c9447e0"
    sha256 cellar: :any_skip_relocation, ventura:        "f1624b00c8caadbc323fe41e3ae6be19823ad19eeeee172e5ec369d86e52ad52"
    sha256 cellar: :any_skip_relocation, monterey:       "ab2878b61b0512430273c2d8326bdf9a3c9d21f647e1f5afd839f921ed436caa"
    sha256 cellar: :any_skip_relocation, big_sur:        "9542ee589a91faaab36ae57316121172f57d40e1f5cbb1750e1481217e7e6cba"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9bc8bbe57c5681ca47bb3e0421f1549789c4db316dcb8ce8f82237344e8b81f9"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/24/85/cf4df939cc0a037ebfe18353005e775916faec24dcdbc7a2f6539ad9d943/filelock-3.12.0.tar.gz"
    sha256 "fc03ae43288c013d2ea83c8597001b1129db351aad9c57fe2409327916b8e718"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/91/17/3836ffe140abb245726d0e21c5b9b984e2569e7027c20d12e969ec69bd8a/platformdirs-3.5.0.tar.gz"
    sha256 "7954a68d0ba23558d753f73437c55f89027cf8f5108c19844d4b82e5af396335"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
