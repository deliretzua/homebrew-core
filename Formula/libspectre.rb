class Libspectre < Formula
  desc "Small library for rendering Postscript documents"
  homepage "https://wiki.freedesktop.org/www/Software/libspectre/"
  url "https://libspectre.freedesktop.org/releases/libspectre-0.2.11.tar.gz"
  sha256 "79d44d65f835c5114592b60355d2fce117bace5c47a62fc63a07f10f133bd49c"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://libspectre.freedesktop.org/releases/"
    regex(/href=.*?libspectre[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "5b77b7b70b98b9881225a0ba573cefdd2933c40e834b660992ded73e95fcd583"
    sha256 cellar: :any,                 arm64_monterey: "18c9b573fb178784cb2d900778bbf853e4af0e7ef4de261beeec4eff380c9f6e"
    sha256 cellar: :any,                 arm64_big_sur:  "d6cc8b05e2314e5c7b13275eb89852375a082599207dce5bafc47afffcbc82a3"
    sha256 cellar: :any,                 monterey:       "b4aa6029c3a9051028013cb02780f82ba7b904f0ca5b13771bfcdfe5cd1c852d"
    sha256 cellar: :any,                 big_sur:        "e9e82a6a1ab0ea85e9214358c2b175e2aeb1540460b06acfb43aa4e3f83c1f60"
    sha256 cellar: :any,                 catalina:       "b2546ae9e2ed88b60225aee8bc6d9b717e6a2377aba0f219afb98e2ceaf1641c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "805296accfe5926181ebaa82c9153620323bae46d2f8f96a4254d17fddf4f26a"
  end

  depends_on "ghostscript"

  def install
    ENV.append "CFLAGS", "-I#{Formula["ghostscript"].opt_include}/ghostscript"
    ENV.append "LIBS", "-L#{Formula["ghostscript"].opt_lib}"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <libspectre/spectre.h>

      int main(int argc, char *argv[]) {
        const char *text = spectre_status_to_string(SPECTRE_STATUS_SUCCESS);
        return 0;
      }
    EOS
    flags = %W[
      -I#{include}
      -L#{lib}
      -lspectre
    ]
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
