class Pipx < Formula
  include Language::Python::Virtualenv

  desc "Execute binaries from Python packages in isolated environments"
  homepage "https://pypa.github.io/pipx"
  url "https://files.pythonhosted.org/packages/66/a1/1efba0467d87a569d2ae3627422334bd9df6ba0db728d1b685ba85f359c9/pipx-0.17.0.tar.gz"
  sha256 "3cb13a918491181b317606cd883bcf573435d535d786aa69bc15a76c7f494de2"
  license "MIT"
  head "https://github.com/pypa/pipx.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7611f705eae9262c0a9f9bbef89646cd602f375afad419d3d5f207092aeb87e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "22661c01c4975aa00370da996f9adbc4bec54db78e73798018122babbb01d908"
    sha256 cellar: :any_skip_relocation, monterey:       "22471f6242b4213ea58a198920dc433434df6daa80094c162c7cefc7352b058a"
    sha256 cellar: :any_skip_relocation, big_sur:        "30d70c14bfa1554c087c9260b053ba8f8d1741c5b249f6e17586de4a8715306d"
    sha256 cellar: :any_skip_relocation, catalina:       "00d93cbabb973e82139659fc6842020416f3d5b3d50824934a6879d9c536e785"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a595071f2e202d5f1f4fbc25e4d32242098ec9a76cb84d38ed30a46575b87533"
  end

  depends_on "python@3.10"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6a/b4/3b1d48b61be122c95f4a770b2f42fc2552857616feba4d51f34611bd1352/argcomplete-1.12.3.tar.gz"
    sha256 "2c7dbffd8c045ea534921e63b0be6fe65e88599990d8dc408ac8c542b72a5445"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/f4/09/ad003f1e3428017d1c3da4ccc9547591703ffea548626f47ec74509c5824/click-8.0.3.tar.gz"
    sha256 "410e932b050f5eed773c4cda94de75971c89cdb3155a72a0831139a79e5ecb5b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/ab/61/1a1613e3dcca483a7aa9d446cb4614e6425eb853b90db131c305bd9674cb/pyparsing-3.0.6.tar.gz"
    sha256 "d9bdec0013ef1eb5a84ab39a3b3868911598afa494f5faa038647101504e2b81"
  end

  resource "userpath" do
    url "https://files.pythonhosted.org/packages/60/2c/0620bacd069a14a601b0a5ba4578b223fa6ae34b9dd97e5508798b7f3dee/userpath-1.7.0.tar.gz"
    sha256 "dcd66c5fa9b1a3c12362f309bbb5bc7992bac8af86d17b4e6b1a4b166a11c43f"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/register-python-argcomplete"

    # Install shell completions
    output = Utils.safe_popen_read(libexec/"bin/register-python-argcomplete", "--shell=bash", "pipx")
    (bash_completion/"pipx").write output

    output = Utils.safe_popen_read(libexec/"bin/register-python-argcomplete", "--shell=fish", "pipx")
    (fish_completion/"pipx.fish").write output
  end

  test do
    assert_match "PIPX_HOME", shell_output("#{bin}/pipx --help")
    system bin/"pipx", "install", "csvkit"
    assert_predicate testpath/".local/bin/csvjoin", :exist?
    system bin/"pipx", "uninstall", "csvkit"
    refute_match "csvjoin", shell_output("#{bin}/pipx list")
  end
end
