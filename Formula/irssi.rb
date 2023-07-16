class Irssi < Formula
  desc "Modular IRC client"
  homepage "https://irssi.org/"
  url "https://github.com/irssi/irssi/releases/download/1.4.4/irssi-1.4.4.tar.xz"
  sha256 "fefe9ec8c7b1475449945c934a2360ab12693454892be47a6d288c63eb107ead"
  license "GPL-2.0-or-later" => { with: "openvpn-openssl-exception" }

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 arm64_ventura:  "576bb2c88cfb864583baceea72d246f5489ee0f2d17a4b2cedefa76253e2c46a"
    sha256 arm64_monterey: "d83017d9cda2ad73f077be22ffd08f157155d34968ba6eecf58a7b0e4c4c6d6e"
    sha256 arm64_big_sur:  "66f1399d3bd85d0b76916ec1e0d4a6a97a9964ca3b045c6763b9c348aa35a5df"
    sha256 ventura:        "0daaf3870649fe1ce73f9fe31c817b9a4f04f2a52dd84b14ff0d77c135dde74c"
    sha256 monterey:       "c75221cd7c3d4110f9661357d00ced37fc649bfac71408910a77fcd16260ce30"
    sha256 big_sur:        "5b3ee4f68f6126a3daf7a1c1c5867b8ae9c401f7796b416944c2f1d36cb33976"
    sha256 x86_64_linux:   "7f06f06ed9c12a97f710a690865d0b549fd88ab346c49876bdfe7f56fea1c27c"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  def install
    args = %W[
      --disable-dependency-tracking
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --with-bot
      --with-proxy
      --enable-true-color
      --with-socks=no
      --with-perl=no
    ]

    system "./configure", *args
    # "make" and "make install" must be done separately on some systems
    system "make"
    system "make", "install"
  end

  test do
    require "pty"

    stdout, = PTY.spawn("#{bin}/irssi -c irc.freenode.net -n testbrew")
    assert_match "Terminal doesn't support cursor movement", stdout.readline

    assert_match version.to_s, shell_output("#{bin}/irssi --version")
  end
end
