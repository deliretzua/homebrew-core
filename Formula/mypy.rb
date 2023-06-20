class Mypy < Formula
  include Language::Python::Virtualenv

  desc "Experimental optional static type checker for Python"
  homepage "http://www.mypy-lang.org/"
  url "https://files.pythonhosted.org/packages/1b/49/c5c7b9445ee563e09e71382e7fb147480fb85fa2356846488114f61549f8/mypy-1.4.0.tar.gz"
  sha256 "de1e7e68148a213036276d1f5303b3836ad9a774188961eb2684eddff593b042"
  license "MIT"
  head "https://github.com/python/mypy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f73cb3ea7d7a731c762139d40c9adf8f83405a712a1dd358327fdbaff5666816"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04b1176e0b1aac14e7a6935d505b967243068be6290febb387da81f081ec875b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4093188b2f85d6e0856571232f09ee3d79632f192ec1890c9762298bf6a8903e"
    sha256 cellar: :any_skip_relocation, ventura:        "3b70e9926c3f70a5f4a12c8bc87d3f29c222716cc6933608e1cda71390843c53"
    sha256 cellar: :any_skip_relocation, monterey:       "a4aa08dd1a220908e03c7204f17e09001c32b00e5654e52b3b9cd1572eac3c07"
    sha256 cellar: :any_skip_relocation, big_sur:        "469557c99876de27edf421576dec8f0ee702e3f741231ad2f7e29a888adf077c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d32b9375d8433260f80bdfe7f250e2e0b8dfea01a2a7eaae602acb4c5fe63138"
  end

  depends_on "python@3.11"

  resource "mypy-extensions" do
    url "https://files.pythonhosted.org/packages/98/a4/1ab47638b92648243faf97a5aeb6ea83059cc3624972ab6b8d2316078d3f/mypy_extensions-1.0.0.tar.gz"
    sha256 "75dbf8955dc00442a438fc4d0666508a9a97b6bd41aa2f0ffe9d2f2725af0782"
  end

  # The `python-typing-extensions` formula depends on `mypy`, so we use a resource here instead
  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/42/56/cfaa7a5281734dadc842f3a22e50447c675a1c5a5b9f6ad8a07b467bffe7/typing_extensions-4.6.3.tar.gz"
    sha256 "d91d5919357fe7f681a9f2b5b4cb2a5f1ef0a1e9f59c4d8ff0d3491e05c0ffd5"
  end

  def install
    ENV["MYPY_USE_MYPYC"] = "1"
    ENV["MYPYC_OPT_LEVEL"] = "3"
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def p() -> None:
        print('hello')
      a = p()
    EOS
    output = pipe_output("#{bin}/mypy broken.py 2>&1")
    assert_match '"p" does not return a value', output

    output = pipe_output("#{bin}/mypy --version 2>&1")
    assert_match "(compiled: yes)", output
  end
end
