class Trzsz < Formula
  include Language::Python::Virtualenv

  desc "Simple file transfer tools, similar to lrzsz (rz/sz), and compatible with tmux"
  homepage "https://trzsz.github.io"
  url "https://files.pythonhosted.org/packages/33/14/5b54b20f4027f23c4dab039a3ac2c73df2b79039c449ebbe2903c98c20e4/trzsz-1.1.3.tar.gz"
  sha256 "4d38e35c128ef86a350bead31cc754c7bbf33ea323d8050ea7ef7d81caf9595e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "76660eb076b8dfcfdd44b0d75c890df839c6d16f2ceaad329fdc95cec35b1e78"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2121245d8531a88d2217c27dc57167d2cd742a7d8c35c210401149fde31d956e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d5426432b5c1d5908e35aea907d84fee26f6751b02873664526a018e904aa882"
    sha256 cellar: :any_skip_relocation, ventura:        "9ba16263135208082786ad514b610c3885ed1e182fcd00cea92a2b9a5217e0bf"
    sha256 cellar: :any_skip_relocation, monterey:       "c356460dba20cd46ab39c3f84badb3f2ec20ee7a9351b8d75257b73e879cebdb"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d70c0ddddb92fb0865667724f020213cc3e98f2533acd5faedfe1b101b359ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2577c4d9b51bed22a190a2d1a3682791f2fe7baf04ebfc71b78b1c77c142722c"
  end

  depends_on "protobuf"
  depends_on "python@3.11"

  resource "iterm2" do
    url "https://files.pythonhosted.org/packages/4f/eb/47bb125fd3b32969f3bc8e0b8997bbe308484ac4d04331ae1e6199ae2c0f/iterm2-2.7.tar.gz"
    sha256 "f6f0bec46c32cecaf7be7fd82296ec4697d4bf2101f0c4aab24cc123991fa230"
  end

  resource "trzsz-iterm2" do
    url "https://files.pythonhosted.org/packages/2d/e2/ef11908cb52c1a66b751c7615c7a62aeaa2ca1c13594fcb8bac4403ce4e5/trzsz-iterm2-1.1.3.tar.gz"
    sha256 "6910e413e65efc14a938a04df7fde5d8c5090f343e572c71e00ff32335fc326f"
  end

  resource "trzsz-libs" do
    url "https://files.pythonhosted.org/packages/9d/7e/59ccff82d9fc525d29721e3e0acd4d3bb0adc9c56e6e56a506009800cba1/trzsz-libs-1.1.3.tar.gz"
    sha256 "dc64e9cfcfeb23ca406932c89755e1141d443c54795eed0d15cec5581de2fc9f"
  end

  resource "trzsz-svr" do
    url "https://files.pythonhosted.org/packages/65/ca/febf965d861a7766fd93349d91f73892abd78b28b30d8ad97b540d1ba07c/trzsz-svr-1.1.3.tar.gz"
    sha256 "e994511688a62b16ce8c1b28f7abf782bccfd8a41728456ba58b5e7fef970c79"
  end

  resource "websockets" do
    url "https://files.pythonhosted.org/packages/d8/3b/2ed38e52eed4cf277f9df5f0463a99199a04d9e29c9e227cfafa57bd3993/websockets-11.0.3.tar.gz"
    sha256 "88fc51d9a26b10fc331be344f1781224a375b78488fc343620184e95a4b27016"
  end

  def install
    virtualenv_install_with_resources
    bin.install_symlink libexec/"bin/trz"
    bin.install_symlink libexec/"bin/tsz"
    bin.install_symlink libexec/"bin/trzsz-iterm2"
  end

  test do
    assert_match "trz (trzsz) py #{version}", shell_output("#{bin}/trz -v")
    assert_match "tsz (trzsz) py #{version}", shell_output("#{bin}/tsz -v")
    assert_match "trzsz-iterm2 (trzsz) py #{version}", shell_output("#{bin}/trzsz-iterm2 -v")

    touch "tmpfile"
    assert_match "Not a directory", shell_output("#{bin}/trz tmpfile 2>&1")

    rm "tmpfile"
    assert_match "No such file", shell_output("#{bin}/tsz tmpfile 2>&1")

    assert_match "arguments are required", shell_output("#{bin}/trzsz-iterm2 2>&1", 2)
  end
end
