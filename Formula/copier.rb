class Copier < Formula
  include Language::Python::Virtualenv

  desc "Utility for rendering projects templates"
  homepage "https://copier.readthedocs.io/"
  url "https://files.pythonhosted.org/packages/80/6f/d51abe285d92598818a16423b4cc94e07153d414f030208f2992f3bd7caa/copier-7.0.1.tar.gz"
  sha256 "3d81916dad27d003674070b365bfcd965eb69d5a97920b226d6db88a6e7193d6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "46493d6f24a945bf2979a004f1e67e235202d7f8ab4e71eb03f63675e223a33e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b99293931ff12f88116c3a23a42ba65e02d9eea2fe528383da15a59dae760f44"
    sha256 cellar: :any_skip_relocation, monterey:       "6f93aa0730f1ce0229d2aeab025251c8fe5cfcb96a168a1d422deab66c3eaaaf"
    sha256 cellar: :any_skip_relocation, big_sur:        "894f7330cff61a72419d3365fb5ae79220ee1cc10b023e2fe96b5cb6a8ae06f2"
    sha256 cellar: :any_skip_relocation, catalina:       "ebacb53422ffaff00097bc4feb40aacd0a4a1d1b65df42dbb2c8636be3a853e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "064e8b305fd3f46c95b78d32075fe193cef55cea2e5bd6c0ef47356c439e20f6"
  end

  depends_on "pygments"
  depends_on "python-typing-extensions"
  depends_on "python@3.10"
  depends_on "pyyaml"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/2b/65/24d033a9325ce42ccbfa3ca2d0866c7e89cc68e5b9d92ecaba9feef631df/colorama-0.4.5.tar.gz"
    sha256 "e6c6b4334fc50988a639d9b98aa429a0b57da6e17b9a44f0451f930b6967b7a4"
  end

  resource "dunamai" do
    url "https://files.pythonhosted.org/packages/ea/9f/0203bb48969f433e81ceae2a04e6cc2f338a43e2f5ef1f49676667c5f314/dunamai-1.13.2.tar.gz"
    sha256 "3bb079c1a84b3dd04a20071e6c914308caba125af98bcef537cabed1a628d989"
  end

  resource "iteration-utilities" do
    url "https://files.pythonhosted.org/packages/0d/27/88eed2efe269faa330f702c02a7b8c98076db9551a8c2e931348b0f78077/iteration_utilities-0.11.0.tar.gz"
    sha256 "f91f41a2549e9a7e40ff5460fdf9033b6ee5b305d9be77943b63a554534c2a77"
  end

  resource "Jinja2" do
    url "https://files.pythonhosted.org/packages/7a/ff/75c28576a1d900e87eb6335b063fab47a8ef3c8b4d88524c4bf78f670cce/Jinja2-3.1.2.tar.gz"
    sha256 "31351a702a408a9e7595a8fc6150fc3f43bb6bf7e319770cbc0db9df9437e852"
  end

  resource "jinja2-ansible-filters" do
    url "https://files.pythonhosted.org/packages/1a/27/fa186af4b246eb869ffca8ffa42d92b05abaec08c99329e74d88b2c46ec7/jinja2-ansible-filters-1.3.2.tar.gz"
    sha256 "07c10cf44d7073f4f01102ca12d9a2dc31b41d47e4c61ed92ef6a6d2669b356b"
  end

  resource "MarkupSafe" do
    url "https://files.pythonhosted.org/packages/1d/97/2288fe498044284f39ab8950703e88abbac2abbdf65524d576157af70556/MarkupSafe-2.1.1.tar.gz"
    sha256 "7f91197cc9e48f989d12e4e6fbc46495c446636dfc81b9ccf50bb0ec74b91d4b"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/df/9e/d1a7217f69310c1db8fdf8ab396229f55a699ce34a203691794c5d1cad0c/packaging-21.3.tar.gz"
    sha256 "dd47c42927d89ab911e606518907cc2d3a1f38bbd026385970643f9c5b8ecfeb"
  end

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/24/9f/a9ae1e6efa11992dba2c4727d94602bd2f6ee5f0dedc29ee2d5d572c20f7/pathspec-0.10.1.tar.gz"
    sha256 "7ace6161b621d31e7902eb6b5ae148d12cfd23f4a249b9ffb6b9fee12084323d"
  end

  resource "plumbum" do
    url "https://files.pythonhosted.org/packages/5f/c9/67b40a607f9815275c7867f9ec60700f442c186d3cca235156cb4fa19c33/plumbum-1.8.0.tar.gz"
    sha256 "f1da1f167a2afe731a85de3f56810f424926c0a1a8fd1999ceb2ef20b618246d"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/80/76/c94cf323ca362dd7baca8d8ddf3b5fe1576848bc0156522ad581c04f8446/prompt_toolkit-3.0.31.tar.gz"
    sha256 "9ada952c9d1787f52ff6d5f3484d0b4df8952787c087edf6a1f7c2cb1ea88148"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/7d/7d/58dd62f792b002fa28cce4e83cb90f4359809e6d12db86eedf26a752895c/pydantic-1.10.2.tar.gz"
    sha256 "91b8e218852ef6007c2b98cd861601c6a09f1aa32bbbb74fab5b1c33d4a1e410"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "pyyaml-include" do
    url "https://files.pythonhosted.org/packages/84/df/c57e47c8d144a424b57304f58661bd09d5bece6c43ac79f3bd4b727f5445/pyyaml-include-1.3.tar.gz"
    sha256 "f7fbeb8e71b50be0e6e07472f7c79dbfb1a15bade9c93a078369ff49e57e6771"
  end

  resource "questionary" do
    url "https://files.pythonhosted.org/packages/04/c6/a8dbf1edcbc236d93348f6e7c437cf09c7356dd27119fcc3be9d70c93bb1/questionary-1.10.0.tar.gz"
    sha256 "600d3aefecce26d48d97eee936fdb66e4bc27f934c3ab6dd1e292c4f43946d90"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/89/38/459b727c381504f361832b9e5ace19966de1a235d73cdbdea91c771a1155/wcwidth-0.2.5.tar.gz"
    sha256 "c4d647b99872929fdb7bdcaa4fbe7f01413ed3d98077df798530e5b04f116c83"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    params = %w[
      -d python=true
      -d js=true
      -d ansible=false
      -d biggest_kbs=1000
      -d main_branches=null
      -d github=true
    ]
    system bin/"copier", *params, "--vcs-ref=v0.1.0", "https://github.com/copier-org/autopretty.git", "template"
    assert (testpath/"template").directory?
    assert_predicate testpath/"template/.copier-answers.autopretty.yml", :exist?
  end
end
