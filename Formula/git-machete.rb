class GitMachete < Formula
  include Language::Python::Virtualenv

  desc "Git repository organizer & rebase workflow automation tool"
  homepage "https://github.com/VirtusLab/git-machete"
  url "https://pypi.org/packages/source/g/git-machete/git-machete-3.17.7.tar.gz"
  sha256 "4eb7bf0912d2c3c17c29197b13786b78790ebcc423dc17e0d8b1ac3d526dd687"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ed6e3b1a6493de9ffb403d6eb18f1ca9276a784b4360f473121018e3c288ef24"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ed6e3b1a6493de9ffb403d6eb18f1ca9276a784b4360f473121018e3c288ef24"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ed6e3b1a6493de9ffb403d6eb18f1ca9276a784b4360f473121018e3c288ef24"
    sha256 cellar: :any_skip_relocation, ventura:        "e890987b4f4fe9290ae84729bf81580c1cd6a2d44bffb658ec3267b2925fc54b"
    sha256 cellar: :any_skip_relocation, monterey:       "e890987b4f4fe9290ae84729bf81580c1cd6a2d44bffb658ec3267b2925fc54b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e890987b4f4fe9290ae84729bf81580c1cd6a2d44bffb658ec3267b2925fc54b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c40459ff01eba8be1d337f4ec39d5d91b01273b0dfaa7988384bc71b2abe540c"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources

    man1.install "docs/man/git-machete.1"

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
