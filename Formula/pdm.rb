class Pdm < Formula
  include Language::Python::Virtualenv

  desc "Modern Python package manager with PEP 582 support"
  homepage "https://pdm.fming.dev"
  url "https://files.pythonhosted.org/packages/c1/a2/15d20b364a70403acb72d54af594cbc85d95d76f71cffc24028284294db7/pdm-1.6.4.tar.gz"
  sha256 "6c3ab53fba8fa33811fd1c3cf4652f05d0081f5e3c2885b8690c874c8d77c999"
  license "MIT"
  head "https://github.com/pdm-project/pdm.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "63be551c91abc01ecfd18cd47107933099a7335ca615312b9f69e86936d2e845"
    sha256 cellar: :any_skip_relocation, big_sur:       "62b305a7bec9049099aacc9e89bfd7abcc2cc8231670c0c9aec5e3162593f7d1"
    sha256 cellar: :any_skip_relocation, catalina:      "4cb101d812b752bff72fe9ed46848dc633034735d834079538be1b4bbb79207c"
    sha256 cellar: :any_skip_relocation, mojave:        "9e118e700656cd5c708a138dd0b383779bbfe68d5aaae32e44a7602da29d6f7b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0a7f575e9e63a16ed8fe8d3c441586adf6742aaf2a99a2862db6315156ffdb7"
  end

  depends_on "python@3.9"
  depends_on "six"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "atoml" do
    url "https://files.pythonhosted.org/packages/a9/06/96184509172e790ab6388f6b793a670f76630f29c7a19990a6cc38f15de3/atoml-1.0.2.tar.gz"
    sha256 "6bb0c219304ad63b0a567227ad34ccfd56c197fafed3120d4eca720b885397a0"
  end

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/ed/d6/3ebca4ca65157c12bd08a63e20ac0bdc21ac7f3694040711f9fd073c0ffb/attrs-21.2.0.tar.gz"
    sha256 "ef6aaac3ca6cd92904cdd0d83f629a15f18053ec84e6432106f7a4d04ae4f5fb"
  end

  resource "cached-property" do
    url "https://files.pythonhosted.org/packages/61/2c/d21c1c23c2895c091fa7a91a54b6872098fea913526932d21902088a7c41/cached-property-1.5.2.tar.gz"
    sha256 "9fa5755838eecbb2d234c3aa390bd80fbd3ac6b6869109bfc1b499f7bd89a130"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/21/83/308a74ca1104fe1e3197d31693a7a2db67c2d4e668f20f43a2fca491f9f7/click-8.0.1.tar.gz"
    sha256 "8c04c11192119b1ef78ea049e0a6f0463e4c48ef00a30160c704337586f3ad7a"
  end

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/1f/bb/5d3246097ab77fa083a61bd8d3d527b7ae063c7d8e8671b1cf8c4ec10cbe/colorama-0.4.4.tar.gz"
    sha256 "5941b2b48a20143d2267e95b1c2a7603ce057ee39fd88e7329b0c292aa16869b"
  end

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/45/97/15fdbef466e12c890553cebb1d8b1995375202e30e0c83a1e51061556143/distlib-0.3.2.zip"
    sha256 "106fef6dc37dd8c0e2c0a60d3fca3e77460a48907f335fa28420463a6f799736"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/86/3c/bcd09ec5df7123abcf695009221a52f90438d877a2f1499453c6938f5728/packaging-20.9.tar.gz"
    sha256 "5b327ac1320dc863dca72f4514ecc086f31186744b84a230374cc1fd776feae5"
  end

  resource "pdm-pep517" do
    url "https://files.pythonhosted.org/packages/39/6f/4a3e1070bd193e9fa3d9a6b3977ac025579816344023d0d9f662583ffe77/pdm-pep517-0.7.4.tar.gz"
    sha256 "538409c63131d6c52ce8dc7dd3d78a033dcdad07f1c71f542add77e70fa9cb55"
  end

  resource "pep517" do
    url "https://files.pythonhosted.org/packages/0f/4c/ac5dc83e7afa327ea9b018a15193a4f1cd8bcce85263a60c127fdcf8ffd3/pep517-0.10.0.tar.gz"
    sha256 "ac59f3f6b9726a49e15a649474539442cf76e0697e39df4869d25e68e880931b"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/c1/47/dfc9c342c9842bbe0036c7f763d2d6686bcf5eb1808ba3e170afdb282210/pyparsing-2.4.7.tar.gz"
    sha256 "c203ec8783bf771a155b207279b9bccb8dea02d8f0c9e5f8ead507bc3246ecc1"
  end

  resource "python-cfonts" do
    url "https://files.pythonhosted.org/packages/b2/7c/8f0fa8f9047bf887bfb8c09b405e429674a4beee5683864cb21b0b8df14e/python-cfonts-1.5.0.tar.gz"
    sha256 "76db1912c65d322abf5ba7be939e7b0862d239d0dee7321a6afb003b26fc8f62"
  end

  resource "python-dotenv" do
    url "https://files.pythonhosted.org/packages/7a/1c/4dbbae00fc9a3bc605fc2d92dc0e197fcf0b6e0357d217d1819afe8206af/python-dotenv-0.18.0.tar.gz"
    sha256 "effaac3c1e58d89b3ccb4d04a40dc7ad6e0275fda25fd75ae9d323e2465e202d"
  end

  resource "pythonfinder" do
    url "https://files.pythonhosted.org/packages/0d/fc/8ce27504a863ec89478f953ee7293ad62e33c3ca0bb659cfc0ca1b37ff3b/pythonfinder-1.2.6.tar.gz"
    sha256 "21ffb77b152ae14c5c7d9b1c98c6df0a1a34d4b3e050da39f561224e7664a5f4"
  end

  resource "resolvelib" do
    url "https://files.pythonhosted.org/packages/0f/79/248bf2687fdaa4a3d8f695a51f03dac38f4c902de7a48b10ccc374bd6b5c/resolvelib-0.7.1.tar.gz"
    sha256 "c526cda7f080d908846262d86c738231d9bfb556eb02d77167b685d65d85ace9"
  end

  resource "shellingham" do
    url "https://files.pythonhosted.org/packages/9c/c9/a3e3bc667c8372a74aa4b16649c3466364cd84f7aacb73453c51b0c2c8a7/shellingham-1.4.0.tar.gz"
    sha256 "4855c2458d6904829bd34c299f11fdeed7cfefbf8a2c522e4caea6cd76b3171e"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "wheel" do
    url "https://files.pythonhosted.org/packages/ed/46/e298a50dde405e1c202e316fa6a3015ff9288423661d7ea5e8f22f589071/wheel-0.36.2.tar.gz"
    sha256 "e11eefd162658ea59a60a0f6c7d493a7190ea4b9a85e335b33489d9f17e0245e"
  end

  def install
    virtualenv_install_with_resources
    (bash_completion/"pdm").write Utils.safe_popen_read("#{bin}/pdm", "completion", "bash")
    (zsh_completion/"_pdm").write Utils.safe_popen_read("#{bin}/pdm", "completion", "zsh")
    (fish_completion/"pdm.fish").write Utils.safe_popen_read("#{bin}/pdm", "completion", "fish")
  end

  test do
    (testpath/"pyproject.toml").write <<~EOS
      [project]
      name = "testproj"
      requires-python = ">=3.9"

    EOS
    system bin/"pdm", "add", "requests==2.24.0"
    assert_match "dependencies = [\n    \"requests==2.24.0\",\n]", (testpath/"pyproject.toml").read
    assert_predicate testpath/"pdm.lock", :exist?
    assert_match "name = \"urllib3\"", (testpath/"pdm.lock").read
    output = shell_output("#{bin}/pdm run python -c 'import requests;print(requests.__version__)'")
    assert_equal "2.24.0", output.strip
  end
end
