class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/12/c5/9e9c1dca8838e1eca43b23e5d8a34a6ad5065f15d702ee703c91b7e64b79/virtualenv-20.22.0.tar.gz"
  sha256 "278753c47aaef1a0f14e6db8a4c5e1e040e90aea654d0fc1dc7e0d8a42616cc3"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fe2c6b70f79d511411b3a9765d568301031c6ad91174960f5d6eb99318a19612"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "266adec6db98929b0589ebff3f4cab50cd6a12402adccbaf6987837f541eb867"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0861b0c40f60d3bcb37daa2d020fd8130eb0a4f5c4dba562027b65e01a1d4abf"
    sha256 cellar: :any_skip_relocation, ventura:        "1f9f429e649c4ed20e7ddcac48708fd3288fc9d149ffd42c218429876ee5c31c"
    sha256 cellar: :any_skip_relocation, monterey:       "d366268f0a0735790df980efc831eb4bb555216bd2d57a3d73f7186e99710dfa"
    sha256 cellar: :any_skip_relocation, big_sur:        "f721b44a1bb1d5ca156cbef1808f6f05af89b4d9d3dd1de14e1e540cee76797e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5f43fc03f801046897772ef446a2c2dea3a6c8d2dbab260ccd025aed824aa22"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/24/85/cf4df939cc0a037ebfe18353005e775916faec24dcdbc7a2f6539ad9d943/filelock-3.12.0.tar.gz"
    sha256 "fc03ae43288c013d2ea83c8597001b1129db351aad9c57fe2409327916b8e718"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/15/04/3f882b46b454ab374ea75425c6f931e499150ec1385a73e55b3f45af615a/platformdirs-3.2.0.tar.gz"
    sha256 "d5b638ca397f25f979350ff789db335903d7ea010ab28903f57b27e1b16c2b08"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
