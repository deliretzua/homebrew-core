class Pure < Formula
  desc "Pretty, minimal and fast ZSH prompt"
  homepage "https://github.com/sindresorhus/pure"
  url "https://github.com/sindresorhus/pure/archive/v1.22.0.tar.gz"
  sha256 "b6a19630d16409550742ec4d4468112b202fcde13a82ee4f2746c8d30e2903f6"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "61509d1bbaad341b215c0c90d7f313c48999e75a5f61857c55b9e7b5e7470eb5"
  end

  depends_on "zsh" => :test
  depends_on "zsh-async"

  def install
    zsh_function.install "pure.zsh" => "prompt_pure_setup"
  end

  test do
    zsh_command = "setopt prompt_subst; autoload -U promptinit; promptinit && prompt -p pure"
    assert_match "❯", shell_output("zsh -c '#{zsh_command}'")
  end
end
