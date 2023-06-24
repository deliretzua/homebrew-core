class CryticCompile < Formula
  include Language::Python::Virtualenv

  desc "Abstraction layer for smart contract build systems"
  homepage "https://github.com/crytic/crytic-compile"
  url "https://files.pythonhosted.org/packages/be/46/f39df1262c9a465c740373314572002650358661c568aaaefa6d81adf1ef/crytic-compile-0.3.2.tar.gz"
  sha256 "adb580d1c79eb6241723a6f1d0f2c6b0d2714b65f07771116b727bed95b48065"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/crytic-compile.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88992b9fd90213acde94f893560f25301e6df5ec97b214181b373714182506c6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7cc3212149488e40aadecc0c5d069d3ef8cbcfbcc2e9094ef2d717e1a9b3f6af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38e4afc309ee1ea55eac6040662721681af43eba8220348373f7ef55c2fd984d"
    sha256 cellar: :any_skip_relocation, ventura:        "9529b1a4b634d1b9c4edecf8ad255a34c7b2e3a278bfb1659b5fd1e2e4f726f6"
    sha256 cellar: :any_skip_relocation, monterey:       "06bcb5238e746e4852d0304ce12b0be8f2bd37a97a10ef62c31da3a33cf30518"
    sha256 cellar: :any_skip_relocation, big_sur:        "e2742aad5f0095f36e6f16d6d085abf67521d1fdafb3b46f1800937bbd8bca06"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66c927e6a01a17bac0f7443261f164993edf7e90bcfeeed04da56eb37ce042dd"
  end

  depends_on "python@3.11"
  depends_on "solc-select"

  resource "cbor2" do
    url "https://files.pythonhosted.org/packages/d9/69/de486293f5211d2e8fe1a19854e69f2811a18448162c52b48c67f8fbcac3/cbor2-5.4.6.tar.gz"
    sha256 "b893500db0fe033e570c3adc956af6eefc57e280026bd2d86fd53da9f1e594d7"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b9/05/0e7547c445bbbc96c538d870e6c5c5a69a9fa5df0a9df3e27cb126527196/pycryptodome-3.18.0.tar.gz"
    sha256 "c9adee653fc882d98956e33ca2c1fb582e23a8af7ac82fee75bd6113c55a0413"
  end

  def install
    virtualenv_install_with_resources
    site_packages = Language::Python.site_packages("python3.11")
    solc_select = Formula["solc-select"].opt_libexec
    (libexec/site_packages/"homebrew-solc-select.pth").write solc_select/site_packages
  end

  test do
    resource "testdata" do
      url "https://github.com/crytic/slither/raw/d0a4f5595d7177b3b7d4bd35e1384bf35ebc22d4/tests/ast-parsing/compile/variable-0.8.0.sol-0.8.15-compact.zip", using: :nounzip
      sha256 "2f165f629882d0250d03a56cb67a84e9741375349195915a04385b0666394478"
    end

    resource("testdata").stage do
      system bin/"crytic-compile", "variable-0.8.0.sol-0.8.15-compact.zip", \
             "--export-format=solc", "--export-dir=#{testpath}/export"
    end

    assert_predicate testpath/"export/combined_solc.json", :exist?
  end
end
