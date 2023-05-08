class Ssocr < Formula
  desc "Seven Segment Optical Character Recognition"
  homepage "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/"
  url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/ssocr-2.23.0.tar.bz2"
  sha256 "ef7f6037943fd84159327289613173114115bb2d9cb364ac4e971c90724188d3"
  license "GPL-3.0-or-later"
  head "https://github.com/auerswal/ssocr.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "imlib2"

  resource "homebrew-test-image" do
    url "https://www.unix-ag.uni-kl.de/~auerswal/ssocr/six_digits.png"
    sha256 "72b416cca7e98f97be56221e7d1a1129fc08d8ab15ec95884a5db6f00b2184f5"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    resource("homebrew-test-image").stage testpath
    assert_equal "431432", shell_output("#{bin}/ssocr -T #{testpath}/six_digits.png").chomp
  end
end
