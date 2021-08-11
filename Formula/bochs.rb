class Bochs < Formula
  desc "Open source IA-32 (x86) PC emulator written in C++"
  homepage "https://bochs.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/bochs/bochs/2.7/bochs-2.7.tar.gz"
  sha256 "a010ab1bfdc72ac5a08d2e2412cd471c0febd66af1d9349bc0d796879de5b17a"
  license "LGPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/bochs[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 arm64_big_sur: "6d5a614bcdfd6fd732e1d970a20cf41ef138544c2fc83c01e40fa76d182d4e7c"
    sha256 big_sur:       "9fc8197b7d04be3b5eafcc970ea167d3a91997ad5e4b30a7d56c0725f61190d4"
    sha256 catalina:      "b6d43a6a60360e0d84ebd2ad9ae7724c413a1f2332c59065fb09c2004d76b723"
    sha256 mojave:        "74fb37178645c4d2b52eec5684931ca215dc2f75794e1cf45b3f6e2b85263819"
    sha256 high_sierra:   "f8c79923292849eebece21d9c5ed1028db729d4d25dc1e045a7c8e0f0dcf450b"
  end

  depends_on "pkg-config" => :build
  depends_on "libtool"
  depends_on "sdl2"

  uses_from_macos "ncurses"

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-docbook
      --enable-a20-pin
      --enable-alignment-check
      --enable-all-optimizations
      --enable-avx
      --enable-evex
      --enable-cdrom
      --enable-clgd54xx
      --enable-cpu-level=6
      --enable-debugger
      --enable-debugger-gui
      --enable-disasm
      --enable-fpu
      --enable-iodebug
      --enable-large-ramfile
      --enable-logging
      --enable-long-phy-address
      --enable-pci
      --enable-plugins
      --enable-readline
      --enable-show-ips
      --enable-usb
      --enable-vmx=2
      --enable-x86-64
      --with-nogui
      --with-sdl2
      --with-term
    ]

    system "./configure", *args

    system "make"
    system "make", "install"
  end

  test do
    require "open3"

    (testpath/"bochsrc.txt").write <<~EOS
      panic: action=fatal
      error: action=report
      info: action=ignore
      debug: action=ignore
      display_library: nogui
    EOS

    expected = <<~EOS
      Bochs is exiting with the following message:
      \[BIOS  \] No bootable device\.
    EOS

    command = "#{bin}/bochs -qf bochsrc.txt"

    # When the debugger is enabled, bochs will stop on a breakpoint early
    # during boot. We can pass in a command file to continue when it is hit.
    (testpath/"debugger.txt").write("c\n")
    command << " -rc debugger.txt"

    _, stderr, = Open3.capture3(command)
    assert_match(expected, stderr)
  end
end
