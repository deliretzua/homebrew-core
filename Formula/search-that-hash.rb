class SearchThatHash < Formula
  include Language::Python::Virtualenv

  desc "Searches Hash APIs to crack your hash quickly"
  homepage "https://github.com/HashPals/Search-That-Hash"
  url "https://files.pythonhosted.org/packages/5e/b9/a304a92ba77a9e18b3023b66634e71cded5285cef7e3b56d3c1874e9d84e/search-that-hash-0.2.8.tar.gz"
  sha256 "384498abbb9a611aa173b20d06b135e013674670fecc01b34d456bfe536e0bca"
  license "GPL-3.0-or-later"
  revision 2
  head "https://github.com/HashPals/Search-That-Hash.git", branch: "main"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8f0f5f15f399cf2f1af5109f0838a900636a5303d86a5507fca48c268c2eae8e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1f5a6ff048c914321115e2894cc3c0f098128220ce5da307478694b7011d1535"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8b88000b1f8e8ac43ac0521ebfdcf9a1da418f5f75a9f22ae64319e309bcf8a4"
    sha256 cellar: :any_skip_relocation, ventura:        "f7e87eec4361c2558149ae22879bf557ea493f49b6ca444d2cc892e6e79bc21d"
    sha256 cellar: :any_skip_relocation, monterey:       "52995d47b3cfc820fc7bc31e5590b513d0084c7445310582d4a364e18116fcd2"
    sha256 cellar: :any_skip_relocation, big_sur:        "7329503b3d606fd62eb78c447d9ce1f1a0f5c311f25772cfd579de2fb868b8a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c7d3154dc0c537026ce94a3656db60afe89e06dc0a5158460df599235476392"
  end

  depends_on "name-that-hash"
  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/ff/d7/8d757f8bd45be079d76309248845a04f09619a7b17d6dfc8c9ff6433cac2/charset-normalizer-3.1.0.tar.gz"
    sha256 "34e0a2f9c370eb95597aae63bf85eb5e96826d81e3dcf88b8886012906f509b5"
  end

  resource "cloudscraper" do
    url "https://files.pythonhosted.org/packages/ac/25/6d0481860583f44953bd791de0b7c4f6d7ead7223f8a17e776247b34a5b4/cloudscraper-1.2.71.tar.gz"
    sha256 "429c6e8aa6916d5bad5c8a5eac50f3ea53c9ac22616f6cb21b18dcc71517d0d3"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "coloredlogs" do
    url "https://files.pythonhosted.org/packages/cc/c7/eed8f27100517e8c0e6b923d5f0845d0cb99763da6fdee00478f91db7325/coloredlogs-15.0.1.tar.gz"
    sha256 "7c991aa71a4577af2f82600d8f8f3a89f936baeaf9b50a9c197da014e5bf16b0"
  end

  resource "humanfriendly" do
    url "https://files.pythonhosted.org/packages/cc/3f/2c29224acb2e2df4d2046e4c73ee2662023c58ff5b113c4c1adac0886c43/humanfriendly-10.0.tar.gz"
    sha256 "6b0b831ce8f15f7300721aa49829fc4e83921a9a301cc7f606be6686a2288ddc"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "loguru" do
    url "https://files.pythonhosted.org/packages/6d/25/0d65383fc7b4f4ce9505d16773b2b2a9f0f465ef00ab337d66afff47594a/loguru-0.5.3.tar.gz"
    sha256 "b28e72ac7a98be3d28ad28570299a393dfcd32e5e3f6a353dec94675767b6319"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/be/10918a2eac4ae9f02f6cfe6414b7a155ccd8f7f9d4380d62fd5b955065c3/requests-2.31.0.tar.gz"
    sha256 "942c5a758f98d790eaed1a29cb6eefc7ffb0d1cf7af05c3d2791656dbd6ad1e1"
  end

  resource "requests-toolbelt" do
    url "https://files.pythonhosted.org/packages/f3/61/d7545dafb7ac2230c70d38d31cbfe4cc64f7144dc41f6e4e4b78ecd9f5bb/requests-toolbelt-1.0.0.tar.gz"
    sha256 "7681a0a3d047012b5bdc0ee37d7f8f07ebe76ab08caeccfc3921ce23c88d5bc6"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/fb/c0/1abba1a1233b81cf2e36f56e05194f5e8a0cec8c03c244cab56cc9dfb5bd/urllib3-2.0.2.tar.gz"
    sha256 "61717a1095d7e155cdb737ac7bb2f4324a858a1e2e6466f6d03ff630ca68d3cc"
  end

  def python3
    "python3.11"
  end

  def install
    # Switch build-system to poetry-core to avoid rust dependency on Linux.
    # Remove when merged/released: https://github.com/HashPals/Search-That-Hash/pull/184
    inreplace "pyproject.toml", 'requires = ["poetry>=0.12"]', 'requires = ["poetry-core>=1.0"]'
    inreplace "pyproject.toml", 'build-backend = "poetry.masonry.api"', 'build-backend = "poetry.core.masonry.api"'

    virtualenv_install_with_resources

    # link dependent virtualenvs to this one
    site_packages = Language::Python.site_packages(python3)
    paths = %w[name-that-hash].map do |package_name|
      package = Formula[package_name].opt_libexec
      package/site_packages
    end
    (libexec/site_packages/"homebrew-deps.pth").write paths.join("\n")

    site_packages = Language::Python.site_packages(python3)
    pth_contents = "import site; site.addsitedir('#{libexec/site_packages}')\n"
    (prefix/site_packages/"homebrew-search_that_hash.pth").write pth_contents
  end

  test do
    hash = "5f4dcc3b5aa765d61d8327deb882cf99"
    output = shell_output("#{bin}/sth --text #{hash}")
    assert_match "#{hash}\n", output
    assert_match "Text : password\nType : MD5\n", output

    system python3, "-c", "from search_that_hash import api"
  end
end
