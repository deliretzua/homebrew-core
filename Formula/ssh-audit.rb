class SshAudit < Formula
  include Language::Python::Virtualenv

  desc "SSH server & client auditing"
  homepage "https://github.com/jtesta/ssh-audit"
  url "https://files.pythonhosted.org/packages/09/71/aa82438fa0660fc0bc63fd84bcc4be8c3f7456752ce31d4fd1221bd63b4c/ssh-audit-2.9.0.tar.gz"
  sha256 "7e68baaaa1fa42b68bcf5eefc81eb02805631e421bd84b6ae639d0cb86eb893d"
  license "MIT"
  head "https://github.com/jtesta/ssh-audit.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "88da564fe01d5d804574d2942814cb310731f827cc9183ff3c9266543c83b33d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88da564fe01d5d804574d2942814cb310731f827cc9183ff3c9266543c83b33d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88da564fe01d5d804574d2942814cb310731f827cc9183ff3c9266543c83b33d"
    sha256 cellar: :any_skip_relocation, ventura:        "9294b5cdcc5f45014d5d4f8289c7976037adfa7a6f4f82d713026df126c1dabf"
    sha256 cellar: :any_skip_relocation, monterey:       "9294b5cdcc5f45014d5d4f8289c7976037adfa7a6f4f82d713026df126c1dabf"
    sha256 cellar: :any_skip_relocation, big_sur:        "9294b5cdcc5f45014d5d4f8289c7976037adfa7a6f4f82d713026df126c1dabf"
    sha256 cellar: :any_skip_relocation, catalina:       "9294b5cdcc5f45014d5d4f8289c7976037adfa7a6f4f82d713026df126c1dabf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49de8dbf2d2f30886de11f3398c04ea45dccd76285b7c8b4f9afafd778ed1490"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match "[exception]", shell_output("#{bin}/ssh-audit -nt 0 ssh.github.com", 1)
  end
end
