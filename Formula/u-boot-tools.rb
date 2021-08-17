class UBootTools < Formula
  desc "Universal boot loader"
  homepage "https://www.denx.de/wiki/U-Boot/"
  url "https://ftp.denx.de/pub/u-boot/u-boot-2021.07.tar.bz2"
  sha256 "312b7eeae44581d1362c3a3f02c28d806647756c82ba8c72241c7cdbe68ba77e"
  license all_of: ["GPL-2.0-only", "GPL-2.0-or-later", "BSD-3-Clause"]

  livecheck do
    url "https://ftp.denx.de/pub/u-boot/"
    regex(/href=.*?u-boot[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "6b4871d6839ee624ddd039dc7e5e59ca7c00d134cf5eb259e1016fba367573eb"
    sha256 cellar: :any,                 catalina:     "16a44059e70ea3e5b304002930aa64676c0523b4d81cd1dca21de82ceb342f76"
    sha256 cellar: :any,                 mojave:       "be9e797cbde27d348dfe240985021a162cc390fe9ecff11e8f56666050830dcf"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "736e048541bf3be0bc7b299672078862e501e01dec9b9d4ffee15a42a7385961"
  end

  depends_on "coreutils" => :build # Makefile needs $(gdate)
  depends_on "openssl@1.1"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build

  def install
    # Replace keyword not present in make 3.81
    inreplace "Makefile", "undefine MK_ARCH", "unexport MK_ARCH"

    system "make", "tools-only_defconfig"
    system "make", "tools-only", "NO_SDL=1"
    bin.install "tools/mkimage"
    bin.install "tools/dumpimage"
    man1.install "doc/mkimage.1"
  end

  test do
    system bin/"mkimage", "-V"
    system bin/"dumpimage", "-V"
  end
end
