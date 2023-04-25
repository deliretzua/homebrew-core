class Breezy < Formula
  include Language::Python::Virtualenv

  desc "Version control system implemented in Python with multi-format support"
  homepage "https://www.breezy-vcs.org/"
  url "https://files.pythonhosted.org/packages/ad/0e/4a937454a5a9e4d2ba7fcb37aeb64c082cddd3fd2761e445a5e11fcfd382/breezy-3.3.2.tar.gz"
  sha256 "4ea6949fcbb076b978545b099fac68abad35d6fa1899deef4f6b82a3dba257c1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "230e71c407e4fec67229957ead35048f038192d0f34034fa1b2c7b366b486ad4"
    sha256 cellar: :any,                 arm64_monterey: "1701a27a93849535e27ce4812b5fac62d018a2073eaf3a5e2ebfdf090ed49240"
    sha256 cellar: :any,                 arm64_big_sur:  "22f05db8be7601e058b2254e104fa59573a4b6336df85410a4146f810d417d81"
    sha256 cellar: :any,                 ventura:        "4754073301e729bc055d682d3308f401507ccb6768c4e7f410f351dddc8b0f30"
    sha256 cellar: :any,                 monterey:       "4a8a3a8fa0b745669c7895a332e4e30541faf7e488cba066940bbf81799904fa"
    sha256 cellar: :any,                 big_sur:        "6e1991c4886348d9de5f963d46ec61104c839723fa36167dbf8df7e109ac961f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e63c0e98e6474db8498d9b6296a23fa4d2fc2fce5c2bd96c16228310a441ccc4"
  end

  depends_on "gettext" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "six"

  conflicts_with "bazaar", because: "both install `bzr` binaries"

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "dulwich" do
    url "https://files.pythonhosted.org/packages/53/a8/c96686cd8e2b0875dbd7d3248c158ff07f2c0ce41857700711a92e97b463/dulwich-0.21.3.tar.gz"
    sha256 "7ca3b453d767eb83b3ec58f0cfcdc934875a341cdfdb0dc55c1431c96608cf83"
  end

  resource "fastbencode" do
    url "https://files.pythonhosted.org/packages/20/ab/33ca3005953d689f1be9c1e0662f5359b7365479f7a8fbd66cb05e9a840d/fastbencode-0.2.tar.gz"
    sha256 "578eb9c4700d6705d71fbc8d7d57bca2cd987eca2cec1d9e77b9e0702db1e56f"
  end

  resource "merge3" do
    url "https://files.pythonhosted.org/packages/dc/91/647a2942b6f308c7dce358bec770fe62ee0689cfd1dd218b66e244acde7d/merge3-0.0.13.tar.gz"
    sha256 "8abda1d2d49776323d23d09bfdd80d943a57d43d28d6152ffd2c87956a9b6b54"
  end

  resource "patiencediff" do
    url "https://files.pythonhosted.org/packages/bf/15/313ca3a72a2c23844002b20171e5c8c0688c1bb640752eb1d35bbe62eda0/patiencediff-0.2.13.tar.gz"
    sha256 "01d642d876186a8f0dd08e77ef1da1940ce49df295477e0713bdc66368e9d8d1"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  def install
    virtualenv_install_with_resources
    bin.each_child do |f|
      f.unlink
      f.write_env_script libexec/"bin"/f.basename, PATH: "#{libexec}/bin:$PATH"
    end
    man1.install_symlink Dir[libexec/"man/man1/*.1"]

    # Replace bazaar with breezy
    bin.install_symlink "brz" => "bzr"
  end

  test do
    brz = "#{bin}/brz"
    whoami = "Homebrew <homebrew@example.com>"
    system brz, "whoami", whoami
    assert_match whoami, shell_output("#{bin}/brz whoami")

    # Test bazaar compatibility
    system brz, "init-repo", "sample"
    system brz, "init", "sample/trunk"
    touch testpath/"sample/trunk/test.txt"
    cd "sample/trunk" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end

    # Test git compatibility
    system brz, "init", "--git", "sample2"
    touch testpath/"sample2/test.txt"
    cd "sample2" do
      system brz, "add", "test.txt"
      system brz, "commit", "-m", "test"
    end
  end
end
