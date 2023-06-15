class Scamper < Formula
  desc "Advanced traceroute and network measurement utility"
  homepage "https://www.caida.org/catalog/software/scamper/"
  url "https://www.caida.org/catalog/software/scamper/code/scamper-cvs-20230614.tar.gz"
  sha256 "26f11ea025a4fdb0d07ef76c5c3b850f9a0a93c1e1aa88d352d600a907259276"
  license "GPL-2.0-only"

  livecheck do
    url "https://www.caida.org/catalog/software/scamper/code/?C=M&O=D"
    regex(/href=.*?scamper(?:-cvs)?[._-]v?(\d{6,8}[a-z]?)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aeb1d9f7d60745d06e0baced1f5d0d532c337976616a62f07f9ae281252c0fa2"
    sha256 cellar: :any,                 arm64_monterey: "15ededff2d13cea0bb7c7a2f835000f06b7cd9f5d33fec9b53b409db58668da9"
    sha256 cellar: :any,                 arm64_big_sur:  "15058a943285b8caf451d4f92938d3b405e617bc685b07bc789cdc2e3cb5d16e"
    sha256 cellar: :any,                 ventura:        "2a120d81b9c48b2c9e48086bdc8703177bc850d8f050a3f615cb807de1dcfe7b"
    sha256 cellar: :any,                 monterey:       "63ca6ffc54fb39bafaae8be782592e8003613aa35718e4f49969ca028984a6a3"
    sha256 cellar: :any,                 big_sur:        "379e2ddedf8a92282a27b767a91617ac5df334bd69664b4a910665ce64e333e8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "000ab9f473cd65f23eba31fa3a0d59bb66693f76bf7ee4ec702c396cb969b327"
  end

  depends_on "pkg-config" => :build
  depends_on "openssl@3"
  depends_on "xz" # for LZMA

  uses_from_macos "zlib"

  def install
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    expected = if OS.mac?
      "dl_bpf_open_dev"
    else
      "scamper_privsep_init"
    end
    assert_match expected, shell_output("#{bin}/scamper -i 127.0.0.1 2>&1", 255)
    assert_match version.to_s, shell_output("#{bin}/scamper -v")
  end
end
