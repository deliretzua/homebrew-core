class Tox < Formula
  include Language::Python::Virtualenv

  desc "Generic Python virtualenv management and test command-line tool"
  homepage "https://tox.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/ac/ee/3115a77ce5af5ac0c5262bee45bdc2d36c02cad13723d7cec970270ccb59/tox-4.0.19.tar.gz"
  sha256 "31d95663dc66f8d53fdf0825f1fc931404b1db5380482c5449628f49db767047"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68abf398611dd5f00c5187bd0dc578517e2e91c04e74c206062240e9b5e67b93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "181135aa5f9b8988328f4c6dfc5f595fb845974e6c34ce7b279209b6a852f505"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "517b0594f3ae0cf8016d197141cf87dbfdb6cb44c2b26c777ec0ec8760c615b2"
    sha256 cellar: :any_skip_relocation, ventura:        "ba2b9d15382fc473325afd8beaa88303583d71f49d0802db42d6761139599b97"
    sha256 cellar: :any_skip_relocation, monterey:       "1c61ae475601f8cd5ad8931e6525e83338ff989ffffd07a645fca3de93858ab5"
    sha256 cellar: :any_skip_relocation, big_sur:        "2a03d89cc8f8e9979f4b690b020cc5c2f188f9120f30ec38d854233fc47e73a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3663bf8c69df50b3662314e0b6e2835f7d0e64ad643a19c332abab9b77f5823e"
  end

  depends_on "python@3.11"
  depends_on "six"

  resource "cachetools" do
    url "https://files.pythonhosted.org/packages/c2/6f/278225c5a070a18a76f85db5f1238f66476579fa9b04cda3722331dcc90f/cachetools-5.2.0.tar.gz"
    sha256 "6a94c6402995a99c3970cc7e4884bb60b4a8639938157eeed436098bf9831757"
  end

  resource "chardet" do
    url "https://files.pythonhosted.org/packages/41/32/cdc91dcf83849c7385bf8e2a5693d87376536ed000807fa07f5eab33430d/chardet-5.1.0.tar.gz"
    sha256 "0d62712b956bc154f85fb0a266e2a3c5913c2967e00348701b32411d6def31e5"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/6b/f7/c240d7654ddd2d2f3f328d8468d4f1f876865f6b9038b146bec0a6737c65/packaging-22.0.tar.gz"
    sha256 "2198ec20bd4c017b8f9717e00f0c8714076fc2fd93816750ab48e2c41de2cfd3"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/62/a3/e4dd832d7ab2dcc68787421ed2cd64562b267c7b6e2a04ebd0e9ad6d271e/platformdirs-2.6.1.tar.gz"
    sha256 "e13f076e0f725f1beb58e7d26f80eff94099941740d3c664db03efecd6561271"
  end

  resource "pluggy" do
    url "https://files.pythonhosted.org/packages/a1/16/db2d7de3474b6e37cbb9c008965ee63835bba517e22cdb8c35b5116b5ce1/pluggy-1.0.0.tar.gz"
    sha256 "4224373bacce55f955a878bf9cfa763c1e360858e330072059e10bad68531159"
  end

  resource "pyproject-api" do
    url "https://files.pythonhosted.org/packages/b8/ec/6f414433d8b924a000ff57e70ea3348182c93f36db77972753f6729b67ef/pyproject_api-1.2.1.tar.gz"
    sha256 "093c047d192ceadcab7afd6b501276bf2ce44adf41cb9c313234518cddd20818"
  end

  resource "virtualenv" do
    url "https://files.pythonhosted.org/packages/7b/19/65f13cff26c8cc11fdfcb0499cd8f13388dd7b35a79a376755f152b42d86/virtualenv-20.17.1.tar.gz"
    sha256 "f8b927684efc6f1cc206c9db297a570ab9ad0e51c16fa9e45487d36d1905c058"
  end

  def install
    virtualenv_install_with_resources
  end

  # Avoid relative paths
  def post_install
    lib_python_path = Pathname.glob(libexec/"lib/python*").first
    lib_python_path.each_child do |f|
      next unless f.symlink?

      realpath = f.realpath
      rm f
      ln_s realpath, f
    end
  end

  test do
    ENV["LC_ALL"] = "en_US.UTF-8"
    pyver = Language::Python.major_minor_version(Formula["python@3.11"].opt_bin/"python3.11").to_s.delete(".")
    (testpath/"tox.ini").write <<~EOS
      [tox]
      envlist=py#{pyver}
      skipsdist=True

      [testenv]
      deps=pytest
      commands=pytest
    EOS
    (testpath/"test_trivial.py").write <<~EOS
      def test_trivial():
          assert True
    EOS
    assert_match "usage", shell_output("#{bin}/tox --help")
    system bin/"tox"
    assert_predicate testpath/".tox/py#{pyver}", :exist?
  end
end
