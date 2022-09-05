class Spaceship < Formula
  desc "Zsh prompt for Astronauts"
  homepage "https://spaceship-prompt.sh"
  url "https://github.com/spaceship-prompt/spaceship-prompt/archive/v4.2.1.tar.gz"
  sha256 "a6cdad0f8b340823acb731d1b63b690d0bc44c31b4bb860ed87fc1fa589e8874"
  license "MIT"
  head "https://github.com/spaceship-prompt/spaceship-prompt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "67d57a8cefb6892c5cc58c6ea01a38f270831d6234305f1619964cf2435e992b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f4dafff84b8ccfe093c07a96e254c1528714e00b6cf6ed282fa55911b07576bc"
    sha256 cellar: :any_skip_relocation, monterey:       "d0a0f80338a5360b25305847726a83da3cc2bdb5b4ace615c4964885fb7916f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "9decc476f544f63dc0b1ffb09fc5f4e75dca4b7061efa89eb68aaaa620837c32"
    sha256 cellar: :any_skip_relocation, catalina:       "0cf43c6d06305783aae0b5514cf71976af96f1880525ef96258eec9def2aa3f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea7651b63185ee2a66f570d128a2b967e237f7ce425807da24078d9b5695a5cc"
  end

  depends_on "zsh-async"
  uses_from_macos "zsh" => :test

  def install
    system "make", "compile"
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      To activate Spaceship, add the following line to ~/.zshrc:
        source "#{opt_prefix}/spaceship.zsh"
      If your .zshrc sets ZSH_THEME, remove that line.
    EOS
  end

  test do
    assert_match "SUCCESS",
      shell_output("zsh -fic '. #{opt_prefix}/spaceship.zsh && (( ${+SPACESHIP_VERSION} )) && echo SUCCESS'")
  end
end
