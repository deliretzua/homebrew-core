class AwsShell < Formula
  include Language::Python::Virtualenv

  desc "Integrated shell for working with the AWS CLI"
  homepage "https://github.com/awslabs/aws-shell"
  url "https://files.pythonhosted.org/packages/01/31/ee166a91c865a855af4f15e393974eadf57762629fc2a163a3eb3f470ac5/aws-shell-0.2.2.tar.gz"
  sha256 "fd1699ea5f201e7cbaacaeb34bf1eb88c8fe6dc6b248bce1b3d22b3e099a41e5"
  license "Apache-2.0"
  revision 2

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a38a8a5307e9e702bba4a8fa6167ae4fc0e104c7ad6fea062d6d0cdfce9a1212"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4c650eed807b6a1323b90a07663e5fa966d8e512ae2610431f79954f3549a95"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30954708665c5ca2f39d5c2943504479d7bfab8a6c778f497e9f2481ec8bcfa6"
    sha256 cellar: :any_skip_relocation, ventura:        "ac71c0c95b7ebe0012063a8f48603813d78c3421871b6f40cd696f8c641a2843"
    sha256 cellar: :any_skip_relocation, monterey:       "891cdde98f362c286d1fb2af7f3c32c683ae30be0ebf7c1eab7b497eb0391a32"
    sha256 cellar: :any_skip_relocation, big_sur:        "147e16067c51e5b6362d0409252385dedad44bae66ddb2cb92dda1b6cb649716"
    sha256 cellar: :any_skip_relocation, catalina:       "d9ff1065eac4653fe94effd49746a53133eda425aea71a38be2512e76725701e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7677437bea5b5f2b365af4449b05417cfe82ee0ef9b5ba5d31b013bdc0071f24"
  end

  depends_on "docutils"
  depends_on "pygments"
  depends_on "python@3.11"
  depends_on "six"

  resource "awscli" do
    url "https://files.pythonhosted.org/packages/79/aa/fd62ca4bb506c69f3d059cbb51a86a7dc03adb513d9b010bb8b1227fa294/awscli-1.27.119.tar.gz"
    sha256 "b5a8c0a842c1cf6fe8c1e3a4900c203e7fb9e12beedd82873e9744e4b541ecb6"
  end

  resource "boto3" do
    url "https://files.pythonhosted.org/packages/0e/10/2c30f3ad343ccf14fdff24daf1859066a0f9f2f1df30e1d63791cf55a493/boto3-1.26.119.tar.gz"
    sha256 "13a041885068d0bfc2104255f2bcb06a1e0c036bcd009ef018f9953b31c20dde"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/e3/84/614b96cf57bf097b50e77f2bb06dbccd82b878f2d3aba9fdfbf630508eb6/botocore-1.29.119.tar.gz"
    sha256 "cd79c7ecf1888dc982ed7e005515324c0e2d7f8aa9ab03a8ee8ece8a2dd3297c"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "configobj" do
    url "https://files.pythonhosted.org/packages/cb/87/17d4c6d634c044ab08b11c0cd2a8a136d103713d438f8792d7be2c5148fb/configobj-5.0.8.tar.gz"
    sha256 "6f704434a07dc4f4dc7c9a745172c1cad449feb548febd9f7fe362629c627a97"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/c5/64/c170e5b1913b540bf0c8ab7676b21fdd1d25b65ddeb10025c6ca43cccd4c/prompt_toolkit-1.0.18.tar.gz"
    sha256 "dd4fca02c8069497ad931a2d09914c6b0d1b50151ce876bc15bde4c747090126"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/61/ef/945a8bcda7895717c8ba4688c08a11ef6454f32b8e5cb6e352a9004ee89d/pyasn1-0.5.0.tar.gz"
    sha256 "97b7290ca68e62a832558ec3976f15cbf911bf5d7c7039d8b861c2a0ece69fde"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/a0/a4/d63f2d7597e1a4b55aa3b4d6c5b029991d3b824b5bd331af8d4ab1ed687d/PyYAML-5.4.1.tar.gz"
    sha256 "607774cbba28732bfa802b54baa7484215f530991055bb562efbed5b2f20a45e"
  end

  resource "rsa" do
    url "https://files.pythonhosted.org/packages/db/b5/475c45a58650b0580421746504b680cd2db4e81bc941e94ca53785250269/rsa-4.7.2.tar.gz"
    sha256 "9d689e6ca1b3038bc82bf8d23e944b6b6037bc02301a574935b2dd946e0353b9"
  end

  resource "s3transfer" do
    url "https://files.pythonhosted.org/packages/e1/eb/e57c93d5cd5edf8c1d124c831ef916601540db70acd96fa21fe60cef1365/s3transfer-0.6.0.tar.gz"
    sha256 "2ed07d3866f523cc561bf4a00fc5535827981b117dd7876f036b0c1aca42c947"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/21/79/6372d8c0d0641b4072889f3ff84f279b738cd8595b64c8e0496d4e848122/urllib3-1.26.15.tar.gz"
    sha256 "8a388717b9476f934a21484e8c8e61875ab60644d29b9b39e11e4b9dc1c6b305"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    # setuptools>=60 prefers its own bundled distutils, which is incompatabile with docutils~=0.15
    # Force the previous behavior of using distutils from the stdlib
    # Remove when fixed upstream: https://github.com/aws/aws-cli/pull/6011
    with_env(SETUPTOOLS_USE_DISTUTILS: "stdlib") do
      virtualenv_install_with_resources
    end
  end

  test do
    system "#{bin}/aws-shell", "--help"
  end
end
