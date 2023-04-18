class Yapf < Formula
  include Language::Python::Virtualenv

  desc "Formatter for python code"
  homepage "https://github.com/google/yapf"
  url "https://files.pythonhosted.org/packages/83/6e/72395cbbd59eedc48913f8694d445acbdba699c50312001b702c5ff46001/yapf-0.33.0.tar.gz"
  sha256 "da62bdfea3df3673553351e6246abed26d9fe6780e548a5af9e70f6d2b4f5b9a"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "950d8ab709fa1abe814841604705099fd1a668025a1ec5c903b59f7f53c9a4ef"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "950d8ab709fa1abe814841604705099fd1a668025a1ec5c903b59f7f53c9a4ef"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "950d8ab709fa1abe814841604705099fd1a668025a1ec5c903b59f7f53c9a4ef"
    sha256 cellar: :any_skip_relocation, ventura:        "1b0f150f316f291060663c5cd8872844c2f127c875f63f67f054a585c87bf0c5"
    sha256 cellar: :any_skip_relocation, monterey:       "1b0f150f316f291060663c5cd8872844c2f127c875f63f67f054a585c87bf0c5"
    sha256 cellar: :any_skip_relocation, big_sur:        "1b0f150f316f291060663c5cd8872844c2f127c875f63f67f054a585c87bf0c5"
    sha256 cellar: :any_skip_relocation, catalina:       "1b0f150f316f291060663c5cd8872844c2f127c875f63f67f054a585c87bf0c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "03c422cc9a467113710a17a468443733350d8f330932b03d77c7a98d11d3e68e"
  end

  depends_on "python@3.11"

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/yapf", "x='homebrew'")
    assert_equal "x = 'homebrew'", output.strip
  end
end
