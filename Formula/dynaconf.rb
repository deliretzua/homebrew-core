class Dynaconf < Formula
  include Language::Python::Virtualenv

  desc "Configuration Management for Python"
  homepage "https://www.dynaconf.com/"
  url "https://files.pythonhosted.org/packages/41/0c/dd30f938dd43e51602a5071fe1cb0707526205ca3ab17d4031842b2c7896/dynaconf-3.2.0.tar.gz"
  sha256 "a28442d12860a44fad5fa1d9db918c710cbfc971e8b7694697429fb8f1c3c620"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "75be4380947cd5ce07a8eb88998f3137e14a1c0c7be0ac66b50ac313f06cfb01"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "75be4380947cd5ce07a8eb88998f3137e14a1c0c7be0ac66b50ac313f06cfb01"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "75be4380947cd5ce07a8eb88998f3137e14a1c0c7be0ac66b50ac313f06cfb01"
    sha256 cellar: :any_skip_relocation, ventura:        "5648d0c69387e98d1253f88dc292a8402142167f1f47ba01556cb882aece135c"
    sha256 cellar: :any_skip_relocation, monterey:       "5648d0c69387e98d1253f88dc292a8402142167f1f47ba01556cb882aece135c"
    sha256 cellar: :any_skip_relocation, big_sur:        "5648d0c69387e98d1253f88dc292a8402142167f1f47ba01556cb882aece135c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3f2ea6b10ca6579d88818a1789c35bb0839eefc4cda58da4ff93ace22d41339c"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"dynaconf", "init"
    assert_predicate testpath/"settings.toml", :exist?
    assert_match "from dynaconf import Dynaconf", (testpath/"config.py").read
  end
end
