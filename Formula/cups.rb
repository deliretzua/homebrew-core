class Cups < Formula
  desc "Common UNIX Printing System"
  homepage "https://github.com/OpenPrinting/cups"
  # This is the author's fork of CUPS. Debian have switched to this fork:
  # https://lists.debian.org/debian-printing/2020/12/msg00006.html
  url "https://github.com/OpenPrinting/cups/releases/download/v2.4.6/cups-2.4.6-source.tar.gz"
  sha256 "58e970cf1955e1cc87d0847c32526d9c2ccee335e5f0e3882b283138ba0e7262"
  license "Apache-2.0"
  head "https://github.com/OpenPrinting/cups.git", branch: "master"

  livecheck do
    url :stable
    regex(/^(?:release[._-])?v?(\d+(?:\.\d+)+(?:op\d*)?)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "d79c24735130185ba8b6ff3b26d8cce4725db870c3537d181d4d2859124ee3f3"
    sha256 arm64_monterey: "b11a96a5482dd27da6e6f8f3b6066dee18dad387dbdea8dae301fabff0f4fa5e"
    sha256 ventura:        "01927756271a3c488ad9c28002f5764d8c41aa8263410a459ad84b979b319102"
    sha256 monterey:       "7027be2f4370e080c66a92f03a1c994a3780082b858c4798dc5124c93b20ff17"
    sha256 x86_64_linux:   "d22a7266c73f0b959b8063a83c226089b4323cadad6ecd4f5c15a64116536b30"
  end

  keg_only :provided_by_macos

  # https://developer.apple.com/documentation/security/3747134-sectrustcopycertificatechain
  # `SecTrustCopyCertificateChain` is on available in monterey or newer
  depends_on macos: :monterey

  uses_from_macos "krb5"
  uses_from_macos "zlib"

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "./configure", *std_configure_args,
                          "--with-components=core",
                          "--without-bundledir"
    system "make", "install"
  end

  test do
    port = free_port.to_s
    pid = fork do
      exec "#{bin}/ippeveprinter", "-p", port, "Homebrew Test Printer"
    end

    begin
      sleep 2
      assert_match("Homebrew Test Printer", shell_output("curl localhost:#{port}"))
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
