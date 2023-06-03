class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https://github.com/jaraco/keyring"
  url "https://files.pythonhosted.org/packages/55/fe/282f4c205add8e8bb3a1635cbbac59d6def2e0891b145aa553a0e40dd2d0/keyring-23.13.1.tar.gz"
  sha256 "ba2e15a9b35e21908d0aaf4e0a47acc52d6ae33444df0da2b49d41a46ef6d678"
  license "MIT"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "30967be155c40d770082fa8ed4e7ca04620d895aa3d2b600a0f14f7dd8c69ffb"
    sha256 cellar: :any,                 arm64_monterey: "7e3e7bbcc33f8696315c36b07c3140a508307564f0a9394b35380218de91e42f"
    sha256 cellar: :any,                 arm64_big_sur:  "344a76de9a7b967bfef9c54ce8654f42fc3af3cf27c61ea73c0b8a42563020e8"
    sha256 cellar: :any,                 ventura:        "c1a60f75ac0a6a693250752ab021e5110ad26c32b37b63a5b09164c96d23442b"
    sha256 cellar: :any,                 monterey:       "72e1e925e9e050bd812bb9d65874401a90ab960e289c683fcaf33276064ea63c"
    sha256 cellar: :any,                 big_sur:        "71b53f3269f7f1c87861f48f6df0b7da9bf219dd00a3de8944189cd11c314b52"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85e687d3e9feb3f82a16e789a0477a457c43d9cb93331465d8db0511d9fe300f"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python@3.11"

  on_linux do
    depends_on "pkg-config" => :build # for cryptography
    depends_on "rust" => :build # for cryptography
    depends_on "openssl@1.1"

    resource "cryptography" do
      url "https://files.pythonhosted.org/packages/19/8c/47f061de65d1571210dc46436c14a0a4c260fd0f3eaf61ce9b9d445ce12f/cryptography-41.0.1.tar.gz"
      sha256 "d34579085401d3f49762d2f7d6634d6b6c2ae1242202e860f4d26b046e3a1006"
    end

    resource "jeepney" do
      url "https://files.pythonhosted.org/packages/d6/f4/154cf374c2daf2020e05c3c6a03c91348d59b23c5366e968feb198306fdf/jeepney-0.8.0.tar.gz"
      sha256 "5efe48d255973902f6badc3ce55e2aa6c5c3b3bc642059ef3a91247bcfcc5806"
    end

    resource "secretstorage" do
      url "https://files.pythonhosted.org/packages/53/a4/f48c9d79cb507ed1373477dbceaba7401fd8a23af63b837fa61f1dcd3691/SecretStorage-3.3.3.tar.gz"
      sha256 "2403533ef369eca6d2ba81718576c5e0f564d5cca1b58f73a8b23e7d4eeebd77"
    end
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/0b/1f/9de392c2b939384e08812ef93adf37684ec170b5b6e7ea302d9f163c2ea0/importlib_metadata-6.6.0.tar.gz"
    sha256 "92501cdf9cc66ebd3e612f1b4f0c0765dfa42f0fa38ffb319b6bd84dd675d705"
  end

  resource "jaraco-classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/2e/d0/bea165535891bd1dcb5152263603e902c0ec1f4c9a2e152cc4adff6b3a38/more-itertools-9.1.0.tar.gz"
    sha256 "cabaa341ad0389ea83c17a94566a53ae4c9d07349861ecb14dc6d0345cf9ac5d"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_empty shell_output("#{bin}/keyring get https://example.com HomebrewTest2", 1)
  end
end
