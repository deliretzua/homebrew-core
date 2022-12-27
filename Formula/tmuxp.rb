class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/c5/fd/e407d794f8512e0c490f147ab3626780a106803f45e95b11e9c08f2bb6df/tmuxp-1.20.0.tar.gz"
  sha256 "e0337874a5cbb5d5e6ba1d70c50a921a413a776c684fa688649f636ee9d0a51f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb0fec68592b20a21c762f582f017ddaa0a7a46ac25cf500f448dd67a57b9e76"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2495188df16c96912aa6cf059a9ef665e56e53837c8318a4795103eba30be33"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b27ef187d293ae13cdbdce75cda60ef8222d549b68338a0762a2080659229732"
    sha256 cellar: :any_skip_relocation, ventura:        "668b415c0356afe763a754078ca9ad693a34b5dc87d998bcabfe4e6e0d3a86c0"
    sha256 cellar: :any_skip_relocation, monterey:       "177d84ab3249defe282557def26f6fbbede057c3666fbd0121eccf0398039afa"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7c43e0b30df5655f5f29853bcbeb23593ab1246618678934bc71448a6465b55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "843cfae7eaf01126df32c6063f2fe7afc0d2bcf43f6468228fca3a51993d498c"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/4a/1c/5c008b7e1baceceb67153f4bc0bb703c8134673fdc948e8c998bed70e137/libtmux-0.17.0.tar.gz"
    sha256 "da270c286198ce85d30ce6a6ac7b72e54de646b6097faf006b3a2ebd68eaee38"
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
