class Jc < Formula
  include Language::Python::Virtualenv

  desc "Serializes the output of command-line tools to structured JSON output"
  homepage "https://github.com/kellyjonbrazil/jc"
  url "https://files.pythonhosted.org/packages/d3/a6/b21f4785ee03d84597dbeeec8bffc6869d2040a47a3864c68ed498a5acab/jc-1.23.3.tar.gz"
  sha256 "e91097121b8f5a553dbb948d1fcc46d220d9b62236d73016eb0d8dad3cd9dc36"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c521587cf38b4d11e7efc7b1a283554ad4366f5861fd04d8c7dd364ad53e1e41"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c521587cf38b4d11e7efc7b1a283554ad4366f5861fd04d8c7dd364ad53e1e41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c521587cf38b4d11e7efc7b1a283554ad4366f5861fd04d8c7dd364ad53e1e41"
    sha256 cellar: :any_skip_relocation, ventura:        "46b4c35de5a0e7d05b709d9d1c7bb9f23d58442bef4a319ff0f1c1473dad6028"
    sha256 cellar: :any_skip_relocation, monterey:       "46b4c35de5a0e7d05b709d9d1c7bb9f23d58442bef4a319ff0f1c1473dad6028"
    sha256 cellar: :any_skip_relocation, big_sur:        "46b4c35de5a0e7d05b709d9d1c7bb9f23d58442bef4a319ff0f1c1473dad6028"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f9f74da170d35fe7c0daa869cf00a01670dc5ce6800c073498f11dbe3b9a1f1"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "ruamel-yaml" do
    url "https://files.pythonhosted.org/packages/63/dd/b4719a290e49015536bd0ab06ab13e3b468d8697bec6c2f668ac48b05661/ruamel.yaml-0.17.32.tar.gz"
    sha256 "ec939063761914e14542972a5cba6d33c23b0859ab6342f61cf070cfc600efc2"
  end

  resource "ruamel-yaml-clib" do
    url "https://files.pythonhosted.org/packages/d5/31/a3e6411947eb7a4f1c669f887e9e47d61a68f9d117f10c3c620296694a0b/ruamel.yaml.clib-0.2.7.tar.gz"
    sha256 "1f08fd5a2bea9c4180db71678e850b995d2a5f4537be0e94557668cf0f5f9497"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jc.1"
    generate_completions_from_executable(bin/"jc", "--bash-comp", shells: [:bash], shell_parameter_format: :none)
    generate_completions_from_executable(bin/"jc", "--zsh-comp", shells: [:zsh], shell_parameter_format: :none)
  end

  test do
    assert_equal "[{\"header1\":\"data1\",\"header2\":\"data2\"}]\n",
                  pipe_output("#{bin}/jc --csv", "header1, header2\n data1, data2")
  end
end
