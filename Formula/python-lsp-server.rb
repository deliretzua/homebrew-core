class PythonLspServer < Formula
  include Language::Python::Virtualenv

  desc "Python Language Server for the Language Server Protocol"
  homepage "https://github.com/python-lsp/python-lsp-server"
  url "https://files.pythonhosted.org/packages/7e/56/b7c8569ab17ed75a858487d26fa5e8f489e72e8d5842107329490c6a6323/python-lsp-server-1.7.4.tar.gz"
  sha256 "c84254485a4d9431b24ecefd59741d21c00165611bcf6037bd7d54d0ed06a197"
  license "MIT"
  head "https://github.com/python-lsp/python-lsp-server.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "47e80469a08de2808310820ccbaaf46918c719ddb381a4460c09f4e941559b6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b8f30603c0449a32d1eb02f0a34f17e7f8fcf4d78e4837b063e5b78b502ecb8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "158999e728ab69a8bbf0be3ea9c48d6ad4172f4b1297ea2d1ac041aa248514e1"
    sha256 cellar: :any_skip_relocation, ventura:        "884bfd971d9c4b016ca05b375b8ca9b86ea929bbd8a850e58669f63cfdd3a0b5"
    sha256 cellar: :any_skip_relocation, monterey:       "27dcec30cb549f3f3855f428578bd779a49b1c849dbc2a30c5b071c8f3bf87ed"
    sha256 cellar: :any_skip_relocation, big_sur:        "35664fb796ec8998c93f8590b2b54eb326c89cf01fad81e177d72bd6af03b3e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a70ef0de7ee3edd03a8d8ca0e1ca3000fa3e6ec9597b0e514c2c09b8a19069f4"
  end

  depends_on "python@3.11"

  resource "docstring-to-markdown" do
    url "https://files.pythonhosted.org/packages/52/c2/6f73c08b97bacd1242835bdca1cfc123b059eb15af9350eb1eb5d58868fc/docstring-to-markdown-0.12.tar.gz"
    sha256 "40004224b412bd6f64c0f3b85bb357a41341afd66c4b4896709efa56827fb2bb"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/15/02/afd43c5066de05f6b3188f3aa74136a3289e6c30e7a45f351546cab0928c/jedi-0.18.2.tar.gz"
    sha256 "bae794c30d07f6d910d32a7048af09b5a39ed740918da923c6b780790ebac612"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/8a/42/8f2833655a29c4e9cb52ee8a2be04ceac61bcff4a680fb338cbd3d1e322d/pluggy-1.2.0.tar.gz"
    sha256 "d12f0c4b579b15f5e054301bb226ee85eeeba08ffec228092f8defbaa3a4c4b3"
  end

  resource "python-lsp-jsonrpc" do
    url "https://files.pythonhosted.org/packages/99/45/1c2a272950679af529f7360af6ee567ef266f282e451be926329e8d50d84/python-lsp-jsonrpc-1.0.0.tar.gz"
    sha256 "7bec170733db628d3506ea3a5288ff76aa33c70215ed223abdb0d95e957660bd"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/15/16/ff0a051f9a6e122f07630ed1e9cbe0e0b769273e123673f0d2aa17fe3a36/ujson-5.8.0.tar.gz"
    sha256 "78e318def4ade898a461b3d92a79f9441e7e0e4d2ad5419abed4336d702c7425"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    json = <<~JSON
      {
        "jsonrpc": "2.0",
        "id": 1,
        "method": "initialize",
        "params": {
          "rootUri": null,
          "capabilities": {}
        }
      }
    JSON
    input = "Content-Length: #{json.size}\r\n\r\n#{json}"
    output = pipe_output("#{bin}/pylsp", input)
    assert_match(/^Content-Length: \d+/i, output)
  end
end
