class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/df/d4/3548a25095740cc6e85e49d5ca10710c8e9d1532ad4bd653b88f71593d50/tmuxp-1.20.1.tar.gz"
  sha256 "1c56397503f4855c9d2f11f4cc3bf2f2e1c5a00657e9d699bcce76b127e0f528"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ec07d2022f105ed1045dff30e8db36839ebf8b1b48641e579038ce2cacfc0ea8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6328efad8337d35cc58781147204ca6e0248733ee87b556c3f66e71ecc002b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9825c3e75afba30e715af3d23af63c690d63505a507f8b467638e56cf91f008b"
    sha256 cellar: :any_skip_relocation, ventura:        "c39c15fd58989474a5f8d31dc9dcce98f7ed0daf32c5a26ca8db7c076136e7c4"
    sha256 cellar: :any_skip_relocation, monterey:       "7d5a50d071485fb4cc713deddaf0113c373b211a8a019a12707cd05c3ac6d31a"
    sha256 cellar: :any_skip_relocation, big_sur:        "58c28e0dd8ca644393a8eb5f1c9c962cf9463fabae4d1e779a1f9c7b426f70ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "574705a720ff06fd44a5453969914ccec8fcd1bb2c7160851b126933b2c1fdb6"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/43/5d/d816098db263e784b08b200915eb797d5b2882d544c1e3e099eafff7bec8/libtmux-0.17.1.tar.gz"
    sha256 "0282d1fca4eb237f749d4933c24db107078fa1d306a7e3bdd3973c594fda1054"
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
