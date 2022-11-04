class AwscliAT1 < Formula
  include Language::Python::Virtualenv

  desc "Official Amazon AWS command-line interface"
  homepage "https://aws.amazon.com/cli/"
  # awscli should only be updated every 10 releases on multiples of 10
  url "https://files.pythonhosted.org/packages/12/db/fd16a26e6b56132841f99e970e800e25f6f6faa4b9affb0024b55793ac77/awscli-1.27.0.tar.gz"
  sha256 "6f4353c770927e4dd5aed5062554f4bcb981c1941bd815dd035f7d5b8ab3f8bf"
  license "Apache-2.0"

  livecheck do
    url "https://github.com/aws/aws-cli.git"
    regex(/^v?(1(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7d8dab9b13df9e0fcbc1a38a864daa3fa04c7f72d29cc51a209c4c050247276a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2623d6e5df0caa41ba2a7420d3e0155112cc67d586d4c05d2c4a86de9e2a107"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "157e7cd2e40852eb1519ca53c3b8bbcfcc653d405871c287976335097363b1e9"
    sha256 cellar: :any_skip_relocation, monterey:       "18872080d496fd99b5b6db97fa080d398f3ea4cabcfc9d8b463f3072d6bdd707"
    sha256 cellar: :any_skip_relocation, big_sur:        "863aa654b42b058e9b298831544f9211b465d277a772945e6882f3834bc74d77"
    sha256 cellar: :any_skip_relocation, catalina:       "796dfe2f54da8fffd126c29966ffd064be47ce441d85a35e7634556c288d513c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "97c83b52e35ce26272e1724e57492a487bf3100516bc3edb9c2fc2dde4b63e27"
  end

  keg_only :versioned_formula

  depends_on "python@3.10"
  depends_on "pyyaml"
  depends_on "six"

  on_system :linux, macos: :ventura_or_newer do
    depends_on "groff"
  end

  resource "botocore" do
    url "https://files.pythonhosted.org/packages/0a/95/8f31139077187f2da9132d7547979262376e19056d99c7cf6278431a53de/botocore-1.29.0.tar.gz"
    sha256 "f25dc0827005f81abf4b890a20c71f64ee40ea9e9795df38a242fdeed79e0a89"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "docutils" do
    url "https://files.pythonhosted.org/packages/2f/e0/3d435b34abd2d62e8206171892f174b180cd37b09d57b924ca5c2ef2219d/docutils-0.16.tar.gz"
    sha256 "c2de3a60e9e7d07be26b7f2b00ca0309c207e06c100f9cc2a94931fc75a478fc"
  end

  resource "jmespath" do
    url "https://files.pythonhosted.org/packages/00/2a/e867e8531cf3e36b41201936b7fa7ba7b5702dbef42922193f05c8976cd6/jmespath-1.0.1.tar.gz"
    sha256 "90261b206d6defd58fdd5e85f478bf633a2901798906be2ad389150c5c60edbe"
  end

  resource "pyasn1" do
    url "https://files.pythonhosted.org/packages/a4/db/fffec68299e6d7bad3d504147f9094830b704527a7fc098b721d38cc7fa7/pyasn1-0.4.8.tar.gz"
    sha256 "aef77c9fb94a3ac588e87841208bdec464471d9871bd5050a287cc9a475cd0ba"
  end

  resource "python-dateutil" do
    url "https://files.pythonhosted.org/packages/4c/c4/13b4776ea2d76c115c1d1b84579f3764ee6d57204f6be27119f13a61d0a9/python-dateutil-2.8.2.tar.gz"
    sha256 "0123cacc1627ae19ddf3c27a5de5bd67ee4586fbdd6440d9748f8abb483d3e86"
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
    url "https://files.pythonhosted.org/packages/b2/56/d87d6d3c4121c0bcec116919350ca05dc3afd2eeb7dc88d07e8083f8ea94/urllib3-1.26.12.tar.gz"
    sha256 "3fa96cf423e6987997fc326ae8df396db2a8b7c667747d47ddd8ecba91f4a74e"
  end

  def install
    virtualenv_install_with_resources
    pkgshare.install "awscli/examples"

    rm Dir["#{bin}/{aws.cmd,aws_bash_completer,aws_zsh_completer.sh}"]
    bash_completion.install "bin/aws_bash_completer"
    zsh_completion.install "bin/aws_zsh_completer.sh"
    (zsh_completion/"_aws").write <<~EOS
      #compdef aws
      _aws () {
        local e
        e=$(dirname ${funcsourcetrace[1]%:*})/aws_zsh_completer.sh
        if [[ -f $e ]]; then source $e; fi
      }
    EOS
  end

  def caveats
    <<~EOS
      The "examples" directory has been installed to:
        #{HOMEBREW_PREFIX}/share/awscli/examples
    EOS
  end

  test do
    assert_match "topics", shell_output("#{bin}/aws help")
  end
end
