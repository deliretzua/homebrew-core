class Nox < Formula
  include Language::Python::Virtualenv

  desc "Flexible test automation for Python"
  homepage "https://nox.thea.codes/"
  url "https://files.pythonhosted.org/packages/e7/3b/529fa8920b18b92085ed5923caee4aee112c65a7af99b34bd5a868b82e3e/nox-2023.4.22.tar.gz"
  sha256 "46c0560b0dc609d7d967dc99e22cb463d3c4caf54a5fda735d6c11b5177e3a9f"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a082553c7384d1ef2882e0a610859ccbc9114ffba6a1dae4d7c34f3981fff57e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "507b1fb89d11ff9e344125b741ea8771cd86816bde225868bf02ba2e1018eee5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "566db514d46ab004a10263dea87157bb0b819085c27c90584c523417211e3b78"
    sha256 cellar: :any_skip_relocation, ventura:        "cda597d7079483ce5efb41f16748fcb34ad46c9de22c05e71dce6aed9283e7ca"
    sha256 cellar: :any_skip_relocation, monterey:       "32f5dce13cd8bf05e54a4e23a99f6fe10bcbbd3c0d11c278b9b43a4809b71f80"
    sha256 cellar: :any_skip_relocation, big_sur:        "f9a0baf93e82dd3197251545d120708ed07b30fbe8e968cd532aa55a55ba9744"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "933fc6c6c179cb34c334d90a6667ad0532b5852592b8a3647f58807a6d637110"
  end

  depends_on "python@3.11"
  depends_on "six"
  depends_on "virtualenv"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/6e/5b/9eae020dad132502efdb51408ba8a5b21afedcb738a98a307c6bfc21aaa8/argcomplete-3.0.6.tar.gz"
    sha256 "9fe49c66ba963b81b64025f74bfbd0275619a6bde1c7370654dc365d4ecc9a0b"
  end

  resource "colorlog" do
    url "https://files.pythonhosted.org/packages/78/6b/4e5481ddcdb9c255b2715f54c863629f1543e97bc8c309d1c5c131ad14f2/colorlog-6.7.0.tar.gz"
    sha256 "bd94bd21c1e13fac7bd3153f4bc3a7dc0eb0974b8bc2fdf1a989e474f6e582e5"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/b9/6c/7c6658d258d7971c5eb0d9b69fa9265879ec9a9158031206d47800ae2213/packaging-23.1.tar.gz"
    sha256 "a392980d2b6cffa644431898be54b0045151319d1e7ec34f0cfed48767dd334f"
  end

  def install
    virtualenv_install_with_resources
    (bin/"tox-to-nox").unlink

    # we depend on virtualenv, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    virtualenv = Formula["virtualenv"].opt_libexec
    (libexec/site_packages/"homebrew-virtualenv.pth").write virtualenv/site_packages
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    (testpath/"noxfile.py").write <<~EOS
      import nox

      @nox.session
      def tests(session):
          session.install("pytest")
          session.run("pytest")
    EOS
    (testpath/"test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    assert_match "usage", shell_output("#{bin}/nox --help")
    assert_match "Sessions defined in #{testpath}/noxfile.py", shell_output("#{bin}/nox --list-sessions")
  end
end
