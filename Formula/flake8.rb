class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/cf/f8/bbe24f43695c0c480181e39ce910c2650c794831886ec46ddd7c40520e6a/flake8-6.1.0.tar.gz"
  sha256 "d5b3857f07c030bdb5bf41c7f53799571d75c4491748a3adcd47de929e34cd23"
  license "MIT"
  head "https://github.com/PyCQA/flake8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9e1fffd844232e4fae4b7ba7b7d34d8af57be04d43ef550c311c751ac7b53fe9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e1fffd844232e4fae4b7ba7b7d34d8af57be04d43ef550c311c751ac7b53fe9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9e1fffd844232e4fae4b7ba7b7d34d8af57be04d43ef550c311c751ac7b53fe9"
    sha256 cellar: :any_skip_relocation, ventura:        "afc41a21bfc1664a09f5618a16a7b2d959e5f48f262855fbc5408162bc064c2e"
    sha256 cellar: :any_skip_relocation, monterey:       "afc41a21bfc1664a09f5618a16a7b2d959e5f48f262855fbc5408162bc064c2e"
    sha256 cellar: :any_skip_relocation, big_sur:        "afc41a21bfc1664a09f5618a16a7b2d959e5f48f262855fbc5408162bc064c2e"
    sha256 cellar: :any_skip_relocation, catalina:       "afc41a21bfc1664a09f5618a16a7b2d959e5f48f262855fbc5408162bc064c2e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "75e22c8fc2e47031ae6a2c30bb10ad607e8f990483c710f4a458d7383ecf3ea7"
  end

  depends_on "python@3.11"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/c1/2d/022c78a6b3f591205e52b4d25c93b7329280f752b36ba2fc1377cbf016cd/pycodestyle-2.11.0.tar.gz"
    sha256 "259bcc17857d8a8b3b4a2327324b79e5f020a13c16074670f9c8c8f872ea76d0"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/8b/fb/7251eaec19a055ec6aafb3d1395db7622348130d1b9b763f78567b2aab32/pyflakes-3.1.0.tar.gz"
    sha256 "a0aae034c444db0071aa077972ba4768d40c830d9539fd45bf4cd3f8f6992efc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-bad.py").write <<~EOS
      print ("Hello World!")
    EOS

    (testpath/"test-good.py").write <<~EOS
      print("Hello World!")
    EOS

    assert_match "E211", shell_output("#{bin}/flake8 test-bad.py", 1)
    assert_empty shell_output("#{bin}/flake8 test-good.py")
  end
end
