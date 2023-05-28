class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/54/f3/3c80d803bc76b8c9ef5857dc782905f3461fce38dde92993258fe572aac9/tmuxp-1.28.0.tar.gz"
  sha256 "4d73d759cca254ef5e230fc4bfc928172f3dc0ad1dc47adcec6008a77ea06158"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "738f1e1ddaea21b16e1f0bfefd21b2d27532de96ba2db4621befe0fc269f6050"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "25c4955f287c49b82b3cbf0a66f0c9739c75013a8e46332523d51c73d743fed3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2cdf6478ba24370e0bf8d34654caccf92dd99ea999f5ecc68ba0038973f9a60b"
    sha256 cellar: :any_skip_relocation, ventura:        "405c4bd65439e5b966e5a9a0ce52002fc74edec0e833b2c81974f1589133db10"
    sha256 cellar: :any_skip_relocation, monterey:       "c38f6d7f52348d38a240d2a93c9cf15b55b985cc1f695fa25fb703753012a8fb"
    sha256 cellar: :any_skip_relocation, big_sur:        "61a0932ba5f93019670ee99992929210fe5652805cbea6cfae1b35f770b23d63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "971ae21d113ff5b950dc70f6f66fe4928724f38d3fbe111afa1b2048b8d1f80d"
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
