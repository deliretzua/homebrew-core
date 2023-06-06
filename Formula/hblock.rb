class Hblock < Formula
  desc "Adblocker that creates a hosts file from multiple sources"
  homepage "https://hblock.molinero.dev/"
  url "https://github.com/hectorm/hblock/archive/v3.4.2.tar.gz"
  sha256 "4b5ff1ddf543d46610ccfa510689f2c11b32eb7561bf76815da853e6f0dd6bcd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "81738da59ef03c9d08da825a5893f84c2ec946e954e4a1872a4d0c9df442f247"
  end

  uses_from_macos "curl"

  def install
    system "make", "install", "prefix=#{prefix}", "bindir=#{bin}", "mandir=#{man}"
  end

  test do
    output = shell_output("#{bin}/hblock -H none -F none -S none -A none -D none -qO-")
    assert_match "Blocked domains:", output
  end
end
