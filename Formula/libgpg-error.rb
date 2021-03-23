class LibgpgError < Formula
  desc "Common error values for all GnuPG components"
  homepage "https://www.gnupg.org/related_software/libgpg-error/"
  url "https://gnupg.org/ftp/gcrypt/libgpg-error/libgpg-error-1.42.tar.bz2"
  sha256 "fc07e70f6c615f8c4f590a8e37a9b8dd2e2ca1e9408f8e60459c67452b925e23"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/libgpg-error/"
    regex(/href=.*?libgpg-error[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "089a2faf07b8eb31c995e7dab97b9e8d5d2fdc77dac8d239ffb391ca4eaf6761"
    sha256 big_sur:       "bc5c5321fa98d6f4dbab215f0e90d9babdcc9c9c801c7ebea9a4423364a13cb7"
    sha256 catalina:      "33969246a46d4cb42c2401c64038cc48601e5fcd41ae21c14d9775c4955fd825"
    sha256 mojave:        "9efc83a76395081c43b5619b4cca8deb794187a7e54cf28e3e7f106aad5093ae"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpg-error-config", prefix, opt_prefix
  end

  test do
    system "#{bin}/gpg-error-config", "--libs"
  end
end
