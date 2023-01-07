class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/7b/a3/8e9c68b703db2a4756704c08893b5b44c3ecae4e0515a9aafdac2604e7bb/tmuxp-1.24.1.tar.gz"
  sha256 "62e961e5bd1daecd0574a0ee38deb1e78cf6798a8d06985dd806e9f9740ca5c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "68e0a74b98a00d7ee854d8a7d66a5a5c4489f541f3c9a11ad0c2ac2b05e50048"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2160f41d0a6e4f503aa7f2f942a19388aeaec624d754bd77d23e1849f1b117d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c8a9d81b71cf2cf11f8a29d7853dadc0393a1af2b3aa42760bd41ee92f5028ab"
    sha256 cellar: :any_skip_relocation, ventura:        "11874c425f811dfe70e43114b6bbd78eb5ffe63541bfab2085a4072dff8fa3b5"
    sha256 cellar: :any_skip_relocation, monterey:       "d57a44697ac4730342639ee651621a0ea5bc180b0b9bfd0c5141116aa26ba139"
    sha256 cellar: :any_skip_relocation, big_sur:        "03ea76415dacb263345e090287f371c710b274a0a6cde1b1b911b667e9fe47f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a37c8f222df0db08c4d93f51f35c5d25927d87f9575fc70be72490c95973bee"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/d2/33/c70c5f119ade04cda33e8fe0bde7a5707f2cefa1c6fb52cdbbadd958e8ab/libtmux-0.18.3.tar.gz"
    sha256 "3ea19ac20498342e2ed8334d18d9dc45a03f9c84c28eb613ed76a2ae38fde141"
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
