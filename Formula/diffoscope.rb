class Diffoscope < Formula
  include Language::Python::Virtualenv

  desc "In-depth comparison of files, archives, and directories"
  homepage "https://diffoscope.org"
  url "https://files.pythonhosted.org/packages/cc/0a/97261ced64fd4e7db04e35ac99521e3c2f87b9da344c6e860fcc46e5b7b2/diffoscope-219.tar.gz"
  sha256 "564af9bf31142b6ba000d2735f65fb45773c0a61e00b9cb8e274694f1b9471e4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f3811db58995eba63ef40249e23d3c449e378b958f8073bbad649b5b1ad2c772"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "783908e27a152227e35e8fd95cc339a26271b16249fb809bff29ba540d8007b7"
    sha256 cellar: :any_skip_relocation, monterey:       "778762bf502c3fe9edc24a6c32eb77eb5657d1d1d6a7fab9a9f661e29a39024b"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ebeb700c64c1f3b3c89a67907b3b51175d739cc621768051b7a13439a056062"
    sha256 cellar: :any_skip_relocation, catalina:       "d08d42b7f5e347491a7b5ecd447301aec961804b17b91e19f4ded637811f3b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fab213e774bc8e71d9f6635e97dd613712746096c4bb0441a98499ef7b3c0f12"
  end

  depends_on "libarchive"
  depends_on "libmagic"
  depends_on "python@3.10"

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
    venv = virtualenv_create(libexec, "python3")
    venv.pip_install resources
    venv.pip_install buildpath

    bin.install libexec/"bin/diffoscope"
    libarchive = Formula["libarchive"].opt_lib/shared_library("libarchive")
    bin.env_script_all_files(libexec/"bin", LIBARCHIVE: libarchive)
  end

  test do
    (testpath/"test1").write "test"
    cp testpath/"test1", testpath/"test2"
    system "#{bin}/diffoscope", "--progress", "test1", "test2"
  end
end
