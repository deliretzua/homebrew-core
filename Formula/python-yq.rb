class PythonYq < Formula
  include Language::Python::Virtualenv

  desc "Command-line YAML and XML processor that wraps jq"
  homepage "https://kislyuk.github.io/yq/"
  url "https://files.pythonhosted.org/packages/70/97/afd9a4999bf7d278803e7a5861a870a5fa7635f68d6f32d86367c542a99e/yq-3.2.0.tar.gz"
  sha256 "be44e0222afdc79d8aa6d8c5f5c5e4e404a278272f23ccf7f3a672fd0750bd55"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f39946c75ed346f336025878451f89c050d87e5742db9553d2c15d82f7e94bb5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2adad568d731c2edc2c01749662013a71497c50563e64f723b6372d2b3495d00"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0616b28424ae076d9d69b2122988eb993614d04dce20cdb636f00d3a8b8c9581"
    sha256 cellar: :any_skip_relocation, ventura:        "7133a60fe44b9ac23c7c2b7f1acdf8b347bd25666baa7cc1559b80bc30ac5399"
    sha256 cellar: :any_skip_relocation, monterey:       "ff3d26f949489f6bfab593cc57efbd2dd1f9f2f99f08e00754c26008aa97fafa"
    sha256 cellar: :any_skip_relocation, big_sur:        "3a700884cd22a3caac6ae2eae49f7f64b49a3ae8b378e2fd67435108758a2d08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c974b566846e4e53eac1735730468cafd789b9b6f8f374a8f2da6a37bc49e9de"
  end

  depends_on "jq"
  depends_on "python@3.11"
  depends_on "pyyaml"

  conflicts_with "yq", because: "both install `yq` executables"

  resource "argcomplete" do
    url "https://files.pythonhosted.org/packages/9d/50/e5b3e9824a387920c4b92870359c9f7dbf21a6cd6d3dff5bf4fd3b50237a/argcomplete-3.0.5.tar.gz"
    sha256 "fe3ce77125f434a0dd1bffe5f4643e64126d5731ce8d173d36f62fa43d6eb6f7"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/4d/4e/6cb8a301134315e37929763f7a45c3598dfb21e8d9b94e6846c87531886c/tomlkit-0.11.7.tar.gz"
    sha256 "f392ef70ad87a672f02519f99967d28a4d3047133e2d1df936511465fbb3791d"
  end

  resource "xmltodict" do
    url "https://files.pythonhosted.org/packages/39/0d/40df5be1e684bbaecdb9d1e0e40d5d482465de6b00cbb92b84ee5d243c7f/xmltodict-0.13.0.tar.gz"
    sha256 "341595a488e3e01a85a9d8911d8912fd922ede5fecc4dce437eb4b6c8d037e56"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    input = <<~EOS
      foo:
       bar: 1
       baz: {bat: 3}
    EOS
    expected = <<~EOS
      3
      ...
    EOS
    assert_equal expected, pipe_output("#{bin}/yq -y .foo.baz.bat", input, 0)
  end
end
