class GitGame < Formula
  desc "Game for git to guess who made which commit"
  homepage "https://github.com/jsomers/git-game"
  url "https://github.com/jsomers/git-game/archive/1.3.tar.gz"
  sha256 "6670c73c2ffe2bc2255566c88f26763100bf0b24a94d3fe10d255712d2a8809e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "c700a65b591b1e95ab45bcd0349a75aeb8fdc9915480c7323a34830cd27075fd"
  end

  uses_from_macos "ruby"

  def install
    bin.install "git-game"
  end

  test do
    system "git", "game", "help"
  end
end
