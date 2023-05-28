class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/68/11/680c4a248cfeaec4aa29cdcbd988455dcc238c77f741ba6210f82e3f708b/tmuxp-1.28.1.tar.gz"
  sha256 "b0d2ea5326ace90635d5e5bf16192a07afaee0c4ea898d62c6f0f704debd1627"
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
    url "https://files.pythonhosted.org/packages/da/36/422236fffc269b4338cfd3028705aefd97803ed8af809473eb38964edadc/libtmux-0.22.1.tar.gz"
    sha256 "794ce91bbe3c754474f06464bd0aed5e984b4d85ff105f0d0eaaaf469c02acb1"
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
