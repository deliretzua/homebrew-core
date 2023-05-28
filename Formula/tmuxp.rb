class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/54/f3/3c80d803bc76b8c9ef5857dc782905f3461fce38dde92993258fe572aac9/tmuxp-1.28.0.tar.gz"
  sha256 "4d73d759cca254ef5e230fc4bfc928172f3dc0ad1dc47adcec6008a77ea06158"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "606c58625a9499dd9e1e45529d96a1382b124332edc096257c1205c5be4d43ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7973d5badbc895b5a930ac550a84c1f9b04ffdf72625183473b269ca5d9269a4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9429059eb9ae4823d8083c871abbac0812e3e763d7686a9347cfd19de54e223"
    sha256 cellar: :any_skip_relocation, ventura:        "8a7ddf7fa89ec218539a7c52e6ea811016294cf0807d9ed60a0d537c4be5b0a1"
    sha256 cellar: :any_skip_relocation, monterey:       "5ab425ac2b24eb01d4332c25c5f17b2b5596213e753326040616efc4d7549320"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a623ce7e4385d040eaf0ba8750beafaada09226640cde2e12d21e5d10082391"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "593d2c5d01dbc08d5581c48be3b804fd9687e9c07aae1935c6d24fbbcc7da5a7"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/c8/a1/3922e2f013f1fdf6e8d9779c3d4a125f9374173d4bb87b97f12361fce471/libtmux-0.22.0.tar.gz"
    sha256 "614ab69692264a8e201ebf6c9e7fcfd619d6c951270041784f89b2acdf51abc6"
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
