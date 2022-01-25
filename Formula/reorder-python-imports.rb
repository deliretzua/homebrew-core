class ReorderPythonImports < Formula
  include Language::Python::Virtualenv

  desc "Rewrites source to reorder python imports"
  homepage "https://github.com/asottile/reorder_python_imports"
  url "https://files.pythonhosted.org/packages/b6/9d/593603be8cc619b022709b85727c80984d2f73304387ba9809026efb5237/reorder_python_imports-2.7.0.tar.gz"
  sha256 "8f6e8ea23905058f964d12a03b7dfb1227d11a877c2d1db0535039a10b568cbb"
  license "MIT"
  head "https://github.com/asottile/reorder_python_imports.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93158d96d4167de3ec9ab06425e38fcaf55eb468543eb557069678fd976660b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93158d96d4167de3ec9ab06425e38fcaf55eb468543eb557069678fd976660b4"
    sha256 cellar: :any_skip_relocation, monterey:       "bbfde8321b875ca00153451dc63a1c82410e3df90eb4f6b5ef13d4b2517c9461"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbfde8321b875ca00153451dc63a1c82410e3df90eb4f6b5ef13d4b2517c9461"
    sha256 cellar: :any_skip_relocation, catalina:       "bbfde8321b875ca00153451dc63a1c82410e3df90eb4f6b5ef13d4b2517c9461"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b29597f500f39ad3e64489fd2783a884faa3d8021e521fd3184340697a9b20a3"
  end

  depends_on "python@3.10"

  resource "aspy.refactor-imports" do
    url "https://files.pythonhosted.org/packages/a9/e9/cabb3bd114aa24877084f2bb6ecad8bd77f87724d239d360efd08f6fe9db/aspy.refactor_imports-2.2.0.tar.gz"
    sha256 "78ca24122963fd258ebfc4a8dc708d23a18040ee39dca8767675821e84e9ea0a"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      from os import path
      import sys
    EOS
    system "#{bin}/reorder-python-imports", "--exit-zero-even-if-changed", "#{testpath}/test.py"
    assert_equal("import sys\nfrom os import path\n", File.read(testpath/"test.py"))
  end
end
