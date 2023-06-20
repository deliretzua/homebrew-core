class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/e0/7a/9020bfa17d294b5d0d8bf26bb175ad4c90d1e3ad4039001f621ef046cb06/yapf-0.40.1.tar.gz"
  sha256 "958587eb5c8ec6c860119a9c25d02addf30a44f75aa152a4220d30e56a98037c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d94edba2aa3f312400cb2052e2d06b681934ce129ffd9cd10121433087fd9025"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8586415ede493322d25f331243d5c4a414478f0592f15c374ecf6bf66e2d429"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f44cb2fe57107ae36b5db7b9c1f3fa872979d81a1adc9eb9fc5731c0c183729b"
    sha256 cellar: :any_skip_relocation, ventura:        "a7458aab0ccaadf00f6893c60efbbb8472bb76785917af41154c0ae6be3bf627"
    sha256 cellar: :any_skip_relocation, monterey:       "cef5ad2a599e78703379b69593bad443bc21ed185b4d46ef6d177ee28ac33f17"
    sha256 cellar: :any_skip_relocation, big_sur:        "70bdfd814ea123998380d6a59c5205979551e8e9ea2c5ae68e6d0a5a1eb1f29a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f24badd2b57c365ea0ce2e6497e746f6f7b9842449889d40e9b735d95eea8b0"
  end

  depends_on "python@3.11"

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/a3/82/f6e29c8d5c098b6be61460371c2c5591f4a335923639edec43b3830650a4/importlib_metadata-6.7.0.tar.gz"
    sha256 "1aaf550d4f73e5d6783e7acb77aec43d49da8017410afae93822cc9cca98c4d4"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/05/31/793923615e85deef0c25abf5d044b3f99f1348b620122ab184b7d3f70f21/platformdirs-3.6.0.tar.gz"
    sha256 "57e28820ca8094678b807ff529196506d7a21e17156cb1cddb3e74cebce54640"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/00/27/f0ac6b846684cecce1ee93d32450c45ab607f65c2e0255f0092032d91f07/zipp-3.15.0.tar.gz"
    sha256 "112929ad649da941c23de50f356a2b5570c954b65150642bccdd66bf194d224b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
