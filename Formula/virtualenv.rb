class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/7c/08/cc69e4b3d499ee9570c4c57f23d5e71ed814fcf03988a4edd3081cb74577/virtualenv-20.24.1.tar.gz"
  sha256 "2ef6a237c31629da6442b0bcaa3999748108c7166318d1f55cc9f8d7294e97bd"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "34f8da79182342a7ff6457ad6b1ec153b2703a98de6bef85dba95e80a32f8d91"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b6c7e42c4ce9c7eef1f81eb49ae9e14dba1a14cc2ed11361cf9e00eb25b19be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "82c3a00575a114c89b8c4d7ed2e46f16bcf9ef39ed735db30f315c82786f87e4"
    sha256 cellar: :any_skip_relocation, ventura:        "21141ecb7d282dc172b82f09df992f3a853bb32cac96c31627fac327b800e40c"
    sha256 cellar: :any_skip_relocation, monterey:       "ce7c8ee77336f266ab2076186f2b88c11bc6eaa71b334f306e54b9ccd8893ae6"
    sha256 cellar: :any_skip_relocation, big_sur:        "af716ccf53d80659069dcc3ad5f0bbfd8ec48635e3e9bcaf64334a2a36229916"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b71f7a4f21e0a2a2f049725aadfabcfdae408ba908e07e69ce4ad73136873c9c"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/29/34/63be59bdf57b3a8a8dcc252ef45c40f3c018777dc8843d45dd9b869868f0/distlib-0.3.7.tar.gz"
    sha256 "9dafe54b34a028eafd95039d5e5d4851a13734540f1331060d31c9916e7147a8"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/00/0b/c506e9e44e4c4b6c89fcecda23dc115bf8e7ff7eb127e0cb9c114cbc9a15/filelock-3.12.2.tar.gz"
    sha256 "002740518d8aa59a26b0c76e10fb8c6e15eae825d34b6fdf670333fd7b938d81"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/a1/70/c1d14c0c58d975f06a449a403fac69d3c9c6e8ae2a529f387d77c29c2e56/platformdirs-3.9.1.tar.gz"
    sha256 "1b42b450ad933e981d56e59f1b97495428c9bd60698baab9f3eb3d00d5822421"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
