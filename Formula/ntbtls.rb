class Ntbtls < Formula
  desc "Not Too Bad TLS Library"
  homepage "https://gnupg.org/index.html"
  url "https://gnupg.org/ftp/gcrypt/ntbtls/ntbtls-0.3.1.tar.bz2"
  sha256 "8922181fef523b77b71625e562e4d69532278eabbd18bc74579dbe14135729ba"
  license "GPL-3.0-or-later"

  depends_on "libgcrypt"
  depends_on "libgpg-error"
  depends_on "libksba"
  uses_from_macos "zlib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-libgpg-error-prefix=#{Formula["libgpg-error"].opt_prefix}",
                          "--with-libgcrypt-prefix=#{Formula["libgcrypt"].opt_prefix}",
                          "--with-libksba-prefix=#{Formula["libksba"].opt_prefix}"
    system "make", "check" # This is a TLS library, so let's run `make check`.
    system "make", "install"
    inreplace bin/"ntbtls-config", prefix, opt_prefix
  end

  test do
    (testpath/"ntbtls_test.c").write <<~C
      #include "ntbtls.h"
      #include <stdio.h>
      int main() {
        printf("%s", ntbtls_check_version(NULL));
        return 0;
      }
    C

    ENV.append_to_cflags shell_output("#{bin}/ntbtls-config --cflags").strip
    ENV.append "LDLIBS", shell_output("#{bin}/ntbtls-config --libs").strip

    system "make", "ntbtls_test"
    assert_equal version.to_s, shell_output("./ntbtls_test")
  end
end
