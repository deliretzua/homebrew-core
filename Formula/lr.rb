class Lr < Formula
  desc "File list utility with features from ls(1), find(1), stat(1), and du(1)"
  homepage "https://github.com/leahneukirchen/lr"
  url "https://github.com/leahneukirchen/lr/archive/refs/tags/v1.5.1.tar.gz"
  sha256 "3c9337b9d924f2318083edc72fa9dfcf571a4af2a411abf57ad12baa5e27cc4a"
  license "MIT"
  head "https://github.com/leahneukirchen/lr.git", branch: "master"

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match(/^\.\n(.*\n)?Library\n/, shell_output("#{bin}/lr -1"))
  end
end
