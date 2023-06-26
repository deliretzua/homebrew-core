class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/60/a0/2a2bfbbab1d9bd4e1a24e3604c30b5d6f84219238f3c98f06191faf5d019/solc-select-1.0.4.tar.gz"
  sha256 "db7b9de009af6de3a5416b80bbe5b6d636bf314703c016319b8c1231e248a6c7"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "20feef6767426974c7df2833b9490c51c2466ae918ae6d7dc50b9e31b2388f70"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e03cbce68b09330067837d9d10c4ff73bfb26ef450d98c08c8aa30be8459fb88"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5792ae00a342be21cccee47d416f6b491b51136724fa9f4982989d093e51ac60"
    sha256 cellar: :any_skip_relocation, ventura:        "fc801e674d1a651b5410248bb80451bd51f589ead811fb5defcdc73def05f535"
    sha256 cellar: :any_skip_relocation, monterey:       "05b87705edaad6bee3fd30d88ef085dfab843b4bcd0994b60eb1e979a97bfc8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "0ec8669cedeb0f26fcaff7cc49bc1a87f5e6f1a79b3e426660ec5f9e6e21f888"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d818396e0ef942ea69441301b0c42b4d5e33c9954bbf79068f22c4c3a5625c5"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/05/0e7547c445bbbc96c538d870e6c5c5a69a9fa5df0a9df3e27cb126527196/pycryptodome-3.18.0.tar.gz"
    sha256 "c9adee653fc882d98956e33ca2c1fb582e23a8af7ac82fee75bd6113c55a0413"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"solc-select", "install", "0.5.7"
    system bin/"solc-select", "install", "0.8.0"
    system bin/"solc-select", "use", "0.5.7"

    assert_match(/0\.5\.7.*current/, shell_output("#{bin}/solc-select versions"))

    # running solc itself requires an Intel system or Rosetta
    return if Hardware::CPU.arm?

    assert_match("0.5.7", shell_output("#{bin}/solc --version"))
    with_env(SOLC_VERSION: "0.8.0") do
      assert_match("0.8.0", shell_output("#{bin}/solc --version"))
    end
  end
end
