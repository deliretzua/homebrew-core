class WlaDx < Formula
  desc "Yet another crossassembler package"
  homepage "https://github.com/vhelin/wla-dx"
  url "https://github.com/vhelin/wla-dx/archive/v9.12.tar.gz"
  sha256 "c5e2b1825cfb88d593379d48bd4971764a83124429e6ecb85ff1150dcf7b78f8"
  license "GPL-2.0"

  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)(?:-fix)*["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "41cd8a0b00bcbc303b13c333cb84b275cf432c67190d85a24e83660fdc9ce5b5"
    sha256 cellar: :any_skip_relocation, big_sur:       "66a1b0e894ef405ba43690d9692c03756db1698deca8f40b6b15340519ec07d9"
    sha256 cellar: :any_skip_relocation, catalina:      "8f0d4747eb9ef0885ddf6c08b3d4ac980bd2b6dbaaa9f5048ea7aa4bc6f681b8"
    sha256 cellar: :any_skip_relocation, mojave:        "b515cc9b31fd4d978143c518555b02873fabff5ef390d369575c3d3e99606326"
    sha256 cellar: :any_skip_relocation, high_sierra:   "0ed73304d947e4ea44431c06df38bb6887a7551f575ade25a6b63ce7b27187c7"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test-gb-asm.s").write <<~EOS
      .MEMORYMAP
       DEFAULTSLOT 1.01
       SLOT 0.001 $0000 $2000
       SLOT 1.2 STArT $2000 sIzE $6000
       .ENDME

       .ROMBANKMAP
       BANKSTOTAL 2
       BANKSIZE $2000
       BANKS 1
       BANKSIZE $6000
       BANKS 1
       .ENDRO

       .BANK 1 SLOT 1

       .ORGA $2000


       ld hl, sp+127
       ld hl, sp-128
       add sp, -128
       add sp, 127
       adc 200
       jr -128
       jr 127
       jr nc, 127
    EOS
    system bin/"wla-gb", "-o", testpath/"test-gb-asm.s"
  end
end
