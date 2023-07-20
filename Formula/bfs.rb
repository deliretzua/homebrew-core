class Bfs < Formula
  desc "Breadth-first version of find"
  homepage "https://tavianator.com/projects/bfs.html"
  url "https://github.com/tavianator/bfs/archive/3.0.1.tar.gz"
  sha256 "a38bb704201ed29f4e0b989fb2ab3791ca51c3eff90acfc31fff424579bbf962"
  license "0BSD"

  depends_on "oniguruma"

  on_linux do
    depends_on "acl"
    depends_on "libcap"
  end

  def install
    system "make", "release"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    touch "foo_file"
    touch "test_file"
    assert_equal "./test_file", shell_output("#{bin}/bfs -name 'test*' -depth 1").chomp
  end
end
