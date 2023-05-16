class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/16/36/184662deb0ced6de6995ef0b01984343d9784914a60ec08a3a988496c63e/Glances-3.4.0.tar.gz"
  sha256 "0b910f377d37961f862eb13964b2a93d6ecf6815b96016c8ab78fe3e4ac4fe53"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "62793e4abb1fec95a439a98122408753444adee8c73ae4625d7b3fc1d053d632"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5e9caf8d44006f8761a66c1eb907453a557fa5eb76379f7c5bdb6251eaba94dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7d561b4d9e62a5f3afa5b9c3830399e36a8cea80490fd8e48b767454c67170ae"
    sha256 cellar: :any_skip_relocation, ventura:        "1d5b77488c87c32406667a790f01e7d46586a7c8f5549e0d040e85c5af79646b"
    sha256 cellar: :any_skip_relocation, monterey:       "d1d5a1485a68d90d73ab582ed69782f25476678b64f900ca835297fdaf562ce3"
    sha256 cellar: :any_skip_relocation, big_sur:        "934e1de0ab2f607b34d82bd834904358bd9ad48958c50bdd199d482824c55a59"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "494b7ddfaecbe3da6ad87c19c34a794ae36d4be4e5aa03aa490fb93504afdd2c"
  end

  depends_on "python@3.11"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/d6/0f/96b7309212a926c1448366e9ce69b081ea79d63265bde33f11cc9cfc2c07/psutil-5.9.5.tar.gz"
    sha256 "5410638e4df39c54d957fc51ce03048acd8e6d60abc0f5107af51e5fb566eb3c"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/43/1a/b0a027144aa5c8f4ea654f4afdd634578b450807bb70b9f8bad00d6f6d3c/ujson-5.7.0.tar.gz"
    sha256 "e788e5d5dcae8f6118ac9b45d0b891a0d55f7ac480eddcb7f07263f2bcf37b23"
  end

  def install
    virtualenv_install_with_resources
    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", out: write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end
