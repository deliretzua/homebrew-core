class Rbtools < Formula
  include Language::Python::Virtualenv

  desc "CLI and API for working with code and document reviews on Review Board"
  homepage "https://www.reviewboard.org/downloads/rbtools/"
  url "https://files.pythonhosted.org/packages/19/ef/8900501b1af41d2485ee1eabb9f3e309f80fdae911c97927d8917ae99f9f/RBTools-4.1.tar.gz"
  sha256 "24efb20346b905c9be0464e747ee1bdee7967d1b94175697ea0c830d929475ff"
  license "MIT"
  head "https://github.com/reviewboard/rbtools.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b0c78646c9b3f5bf3901902122d0835e00c8adbeb34886d765888a34c6505960"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "259be5e7eac1be107f3ab7f0cd97e39a48376ab4ebb6f4e08f0e56b6d21a01ba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57bc64193f6c2b156e719f5d60779693a487060279542274b4142ae33251eb1c"
    sha256 cellar: :any_skip_relocation, ventura:        "3e19b6d11c68dce31cac490b0c41c366eb7f2fbe76cd1bae0fcf6fa86a0fc07b"
    sha256 cellar: :any_skip_relocation, monterey:       "2f2aac7ec3b8ee6cb675a780d4d75e758f302948c7ab72a335969d356d5f683c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5ad603c0a25683d3350949e6796beab8f558138bd31521d04617df17ad542203"
    sha256 cellar: :any_skip_relocation, catalina:       "e6616acfb3f1df1b2896644a3c5f9e9bdd9e41e12ce9a8d977a15630861b424a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e9a2e1211ddb4c3a444602a0977e6d00cc7b9acad2a0676c5771cbaae8ad89c0"
  end

  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "six"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/93/71/752f7a4dd4c20d6b12341ed1732368546bc0ca9866139fe812f6009d9ac7/certifi-2023.5.7.tar.gz"
    sha256 "0f0d56dc5a6ad56fd4ba36484d6cc34451e1c6548c61daad8c320169f91eddc7"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "pydiffx" do
    url "https://files.pythonhosted.org/packages/d3/76/ad0677d82b7c75deb4da63151d463a9f90e97f3817b83f4e3f74034eb384/pydiffx-1.1.tar.gz"
    sha256 "0986dbb0a87cbf79e244e2f1c0e2b696d8e86b3861ea2955757a61d38e139228"
  end

  resource "texttable" do
    url "https://files.pythonhosted.org/packages/e4/84/4686ee611bb020038375c5f11fe7b6b3bb94ee78614a1faba45effe51591/texttable-1.6.7.tar.gz"
    sha256 "290348fb67f7746931bcdfd55ac7584ecd4e5b0846ab164333f0794b121760f2"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/3d/78/81191f56abb7d3d56963337dbdff6aa4f55805c8afd8bad64b0a34199e9b/tqdm-4.65.0.tar.gz"
    sha256 "1871fb68a86b8fb3b59ca4cdd3dcccbc7e6d613eeed31f4c332531977b89beb5"
  end

  def install
    virtualenv_install_with_resources
    bash_completion.install "rbtools/commands/conf/rbt-bash-completion" => "rbt"
    zsh_completion.install "rbtools/commands/conf/_rbt-zsh-completion" => "_rbt"
  end

  test do
    system "git", "init"
    system "#{bin}/rbt", "setup-repo", "--server", "https://demo.reviewboard.org"
    out = shell_output("#{bin}/rbt clear-cache")
    assert_match "Cleared cache in", out
  end
end
