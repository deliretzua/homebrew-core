class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/ec/65/00bec8751a608a96d73345bc8e47e4ce1f87729eb21af6febad1d2f99c37/tmuxp-1.26.0.tar.gz"
  sha256 "02e31db03a60a932640f13a5f6afa54ae321ae02ff9a8516a30a6dfa2391df64"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "176749c58209dbb98cddd31cfd59b9e2fa5fb874f0cdd3af2a779e9dff43c092"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0cb02265d001f32b0ecd33c95387becece49962cbe3622f3278f64620ea6c22"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3a99ddcd85bffd2f8dd1dbd192ef6a3e859f7385cbaa579442453be81c60f977"
    sha256 cellar: :any_skip_relocation, ventura:        "7b645e2f4952a162ab6ed64be702b779e1f23e1462a4189a29a26fd4968b28f8"
    sha256 cellar: :any_skip_relocation, monterey:       "78640fb6b3e7fc419bb443065805e96d911391ae4aaa71c098d44c6a9aab0b7d"
    sha256 cellar: :any_skip_relocation, big_sur:        "7d370edfc5f20ba914eb76fdc1809e6d5d9dd2cad584f1cd5460fffa22989e9f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f21d425f2f294519da87a46831959a5fe9a414320730ac90985a320036a69593"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/0f/c7/5036714eb6c83d5d315069c79fe260149f2cd27591f345b849d120707c2b/libtmux-0.20.0.tar.gz"
    sha256 "5a4dcc01c52888970c0d515d63c7559b702055d3f53bec716c6a7de48fe88dd3"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~EOS
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    EOS

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_predicate testpath/"test_session.json", :exist?
  end
end
