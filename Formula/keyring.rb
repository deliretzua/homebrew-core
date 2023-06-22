class Keyring < Formula
  include Language::Python::Virtualenv

  desc "Easy way to access the system keyring service from python"
  homepage "https://github.com/jaraco/keyring"
  url "https://files.pythonhosted.org/packages/31/42/f29907a72907df16326fa425cfd3a144f00d9a613063467f8b58d2ac58a5/keyring-24.0.0.tar.gz"
  sha256 "4e87665a19c514c7edada8b15015cf89bd99b8d7edabc5c43cca77166fa8dfad"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6714add9cbf6fea2e8da0b8914c488d48a75637b35b0a7416fb6212f521eff85"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cf56508398783d7b97c6333ea7c74ff27370468cbb81db7ca4acb553af07a7c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "74b2068657de1c7f7c34f8e3fbbab5e2e95d67e873d46652ee64c83ae0968ba2"
    sha256 cellar: :any_skip_relocation, ventura:        "96d1c37c9266fd66f9a794730de091a0ecbfecc5659bc0ca970175aa25a6b73d"
    sha256 cellar: :any_skip_relocation, monterey:       "f1094542d5ba286fb7d58c527dd8ad0d3347b4144bb43a9fcac1d46760491f9c"
    sha256 cellar: :any_skip_relocation, big_sur:        "3371e9571b9bcf187675c2e1c4b1c2d0181b870a2f8ba4481ef690130a345a41"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d1ed467a96d16ce7ffe335a72ea2917aacfca8b6e644d2d8f81d0ec132cdbb03"
  end

  depends_on "cffi"
  depends_on "pycparser"
  depends_on "python@3.11"

  on_linux do
    # `pkg-config`, `rust`, and `openssl@3` are for cryptography.
    depends_on "pkg-config" => :build
    depends_on "rust" => :build
    depends_on "openssl@3"

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
    url "https://files.pythonhosted.org/packages/a3/82/f6e29c8d5c098b6be61460371c2c5591f4a335923639edec43b3830650a4/importlib_metadata-6.7.0.tar.gz"
    sha256 "1aaf550d4f73e5d6783e7acb77aec43d49da8017410afae93822cc9cca98c4d4"
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
    if OS.linux?
      # Ensure that the `openssl` crate picks up the intended library.
      ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
      ENV["OPENSSL_NO_VENDOR"] = "1"
    end

    virtualenv_install_with_resources
  end

  test do
    assert_empty shell_output("#{bin}/keyring get https://example.com HomebrewTest2", 1)
  end
end
