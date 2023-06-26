class Lesspipe < Formula
  desc "Input filter for the pager less"
  homepage "https://www-zeuthen.desy.de/~friebel/unix/lesspipe.html"
  url "https://github.com/wofr06/lesspipe/archive/v2.08.tar.gz"
  sha256 "91b1363ba9b5594fa4285717592d712a6c724ae7ee35a9543127b3d64677c0d2"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c2156478a5b6006415e8d51dfaa6eef48f4f9b65a2166c8a3deace997809e3b2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c2156478a5b6006415e8d51dfaa6eef48f4f9b65a2166c8a3deace997809e3b2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c2156478a5b6006415e8d51dfaa6eef48f4f9b65a2166c8a3deace997809e3b2"
    sha256 cellar: :any_skip_relocation, ventura:        "c2156478a5b6006415e8d51dfaa6eef48f4f9b65a2166c8a3deace997809e3b2"
    sha256 cellar: :any_skip_relocation, monterey:       "c2156478a5b6006415e8d51dfaa6eef48f4f9b65a2166c8a3deace997809e3b2"
    sha256 cellar: :any_skip_relocation, big_sur:        "c2156478a5b6006415e8d51dfaa6eef48f4f9b65a2166c8a3deace997809e3b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ceb4e96042a617340ea075043fa7baa75056229a80270f9dcb9f0e4f411415df"
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    man1.mkpath
    system "make", "install"
  end

  def caveats
    <<~EOS
      add the following to your shell profile e.g. ~/.profile or ~/.zshrc:
        export LESSOPEN="|#{HOMEBREW_PREFIX}/bin/lesspipe.sh %s"
    EOS
  end

  test do
    touch "file1.txt"
    touch "file2.txt"
    system "tar", "-cvzf", "homebrew.tar.gz", "file1.txt", "file2.txt"

    assert_predicate testpath/"homebrew.tar.gz", :exist?
    assert_match "file2.txt", pipe_output(bin/"archive_color", shell_output("tar -tvzf homebrew.tar.gz"))
  end
end
