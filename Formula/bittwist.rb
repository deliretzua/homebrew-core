class Bittwist < Formula
  desc "Libcap-based Ethernet packet generator"
  homepage "https://bittwist.sourceforge.io"
  url "https://downloads.sourceforge.net/project/bittwist/macOS/Bit-Twist%203.6/bittwist-macos-3.6.tar.gz"
  sha256 "484339e5672c454aeef7ee834e33acad2d2fc04a4c9a9dc32924c0316a2530dc"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8c6076c177846396c74e3d3e9bf4157a5b0c2eaf062f46c17ef9b3a3fa9ea68e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d22bf78930574b5cc076d914b29d5166e1a13e2a38daa1be223992ad5adea6de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0574058e37dd44fb67d7b6610d52db7acf0284a79f1e9325c6bb06fdb6253a93"
    sha256 cellar: :any_skip_relocation, ventura:        "3542eebd87db3452b8bfbea1c595e15424417af9bbbac5a4dbffdbdbd45481a6"
    sha256 cellar: :any_skip_relocation, monterey:       "f7ce940dbfcecf99fe037ae0aa7c6728a408b271bb17d9b0baa302a756ef05f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "e48872fd33d76e55e3b7def041dd085787f64f94220479ca217c76c751d4f126"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9e44d0b2c68d073c094fc8b3a1ffb65e48ce15eaa17d97e8ee30f30163bc7876"
  end

  uses_from_macos "libpcap"

  def install
    system "make"
    system "make", "install", "prefix=#{prefix}"
  end

  test do
    system "#{bin}/bittwist", "-help"
    system "#{bin}/bittwiste", "-help"
  end
end
