class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/08/db/afa529b58e0a5dc4d481515902f06660cacef1bb21518133c49154c3dfb2/diffoscope-240.tar.gz"
  sha256 "79e30534e348a95caf2f4d7138403ba4a44e64a0777a98b71b7d8873635ce302"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a924af295e39861a9a3e7b08345f72f2da889c30db097866d6e29021a41649aa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d9bf06991884c97d01fee62e2bc91e0c80cb5504ece66e8d5a0ecc73f2961577"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20c777d1a756a4785f4e38afedc831a4747b4b3391120fff08c01504b8efa1f9"
    sha256 cellar: :any_skip_relocation, ventura:        "156ed16280d456140fe84aeb0d8b89a30a819bf49e6699e5309d1001bb91b501"
    sha256 cellar: :any_skip_relocation, monterey:       "132ff7ecd78f4590e17fcbaa322e2a354da27429b379ff084987182f247fa5d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "66fdf34041d9910b2f7339f63f90a447ac1c300ca10e58f13ce26ed8c4432dbd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "454b1df993a67e904bee8fb150045a3282c32324354d6d173f59acbb34986654"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/9d/50/e5b3e9824a387920c4b92870359c9f7dbf21a6cd6d3dff5bf4fd3b50237a/argcomplete-3.0.5.tar.gz"
    sha256 "fe3ce77125f434a0dd1bffe5f4643e64126d5731ce8d173d36f62fa43d6eb6f7"
  end

  resource "libarchive-c" do
    url "https://files.pythonhosted.org/packages/93/c4/d8fa5dfcfef8aa3144ce4cfe4a87a7428b9f78989d65e9b4aa0f0beda5a8/libarchive-c-4.0.tar.gz"
    sha256 "a5b41ade94ba58b198d778e68000f6b7de41da768de7140c984f71d7fa8416e5"
  end

  resource "progressbar" do
    url "https://files.pythonhosted.org/packages/a3/a6/b8e451f6cff1c99b4747a2f7235aa904d2d49e8e1464e0b798272aa84358/progressbar-2.5.tar.gz"
    sha256 "5d81cb529da2e223b53962afd6c8ca0f05c6670e40309a7219eacc36af9b6c63"
  end

  resource "python-magic" do
    url "https://files.pythonhosted.org/packages/da/db/0b3e28ac047452d079d375ec6798bf76a036a08182dbb39ed38116a49130/python-magic-0.4.27.tar.gz"
    sha256 "c1ba14b08e4a5f5c31a302b7721239695b2f0f058d125bd5ce1ee36b9d9d3c3b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system bin/"diffoscope", "--progress", "test1", "test2"
  end
end
