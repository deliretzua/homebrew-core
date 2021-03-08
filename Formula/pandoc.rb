class Pandoc < Formula
  desc "Swiss-army knife of markup format conversion"
  homepage "https://pandoc.org/"
  url "https://hackage.haskell.org/package/pandoc-2.12/pandoc-2.12.tar.gz"
  sha256 "5517f22b3c026d19d5904f9cccdaaa2aeb49239fb49d6757524047e93034f27c"
  license "GPL-2.0-or-later"
  head "https://github.com/jgm/pandoc.git"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:  "2bdbf3d2f77426ffc5c3af071c2063db4082475837f479499412ef187a4dfb1a"
    sha256 cellar: :any_skip_relocation, catalina: "29e30b1de3a6462a669b2a78043d3f240a4d5d3c6f8cac07997a2f7d2f77991f"
    sha256 cellar: :any_skip_relocation, mojave:   "7cdbea784987ad599c69fa8f83f0d6b093957bba848eb3d52e859ab977345fa6"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  uses_from_macos "unzip" => :build # for cabal install
  uses_from_macos "zlib"

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
    (bash_completion/"pandoc").write `#{bin}/pandoc --bash-completion`
    man1.install "man/pandoc.1"
  end

  test do
    input_markdown = <<~EOS
      # Homebrew

      A package manager for humans. Cats should take a look at Tigerbrew.
    EOS
    expected_html = <<~EOS
      <h1 id="homebrew">Homebrew</h1>
      <p>A package manager for humans. Cats should take a look at Tigerbrew.</p>
    EOS
    assert_equal expected_html, pipe_output("#{bin}/pandoc -f markdown -t html5", input_markdown)
  end
end
