class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.12.5.tar.gz"
  sha256 "07d930ddb5c946d45c37e13882b2fefdeecbea935d31b3512cc482c64beaf187"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb246889778d307ab8d63ce107a4ca52c5d1cd30dd98bcfce44b277cefeea264"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb246889778d307ab8d63ce107a4ca52c5d1cd30dd98bcfce44b277cefeea264"
    sha256 cellar: :any_skip_relocation, monterey:       "6342587712d3ba02e4f960fbfcf332abe4364cdc697a02fb348f42768fe83736"
    sha256 cellar: :any_skip_relocation, big_sur:        "6342587712d3ba02e4f960fbfcf332abe4364cdc697a02fb348f42768fe83736"
    sha256 cellar: :any_skip_relocation, catalina:       "6342587712d3ba02e4f960fbfcf332abe4364cdc697a02fb348f42768fe83736"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a71daa35dded0944b9f57da55fb44269ee98f588206b7e24bae279425ca6203"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources

    bash_completion.install "completion/git-machete.completion.bash"
    zsh_completion.install "completion/git-machete.completion.zsh"
    fish_completion.install "completion/git-machete.fish"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "you@example.com"
    system "git", "config", "user.name", "Your Name"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "Initial commit"
    system "git", "branch", "-m", "main"
    system "git", "checkout", "-b", "develop"
    (testpath/"test2").write "bar"
    system "git", "add", "test2"
    system "git", "commit", "--message", "Other commit"

    (testpath/".git/machete").write "main\n  develop"
    expected_output = "  main\n  |\n  | Other commit\n  o-develop *\n"
    assert_equal expected_output, shell_output("git machete status --list-commits")
  end
end
