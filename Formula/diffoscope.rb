class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/78/73/788421456661a8f1a8fabacb2abb489e5ed3b28879f240ce31ceb367f2d8/diffoscope-229.tar.gz"
  sha256 "4c592cd3e5dc26bae97f37b880fc66cac152c2aca4b8ce481a9b63768139d452"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e773b1acb45a724d552b76ba57ccb27809b82957b342879a2952285a6bffc4a4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "329892ed2ec150bc3c0d3246bf42b07ec1fb5c64facb6a5573eb475c2fc7594a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "92072a359b7a81d6e29d8f43433f98d5dd5913acfbb9503c649ec87494ee0cb2"
    sha256 cellar: :any_skip_relocation, ventura:        "b6216fefaf8a041ecb99abc4f374a4228504a1084c950364c13817312d83a896"
    sha256 cellar: :any_skip_relocation, monterey:       "88b9c25efe11c3be557fd6ca50e3267426ac0b0a85c4db92948852187788bfb6"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a82154817363c962f0e215aebe31af7f8e81c1e868db4e7dd3004a386859b18"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2d347260c6155f75173a89845d299c345f79e140097542c899fe9bfaf848352"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.11"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/05/f8/67851ae4fe5396ba6868c5d84219b81ea6a5d53991a6853616095c30adc0/argcomplete-2.0.0.tar.gz"
    sha256 "6372ad78c89d662035101418ae253668445b391755cfe94ea52f1b9d22425b20"
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
