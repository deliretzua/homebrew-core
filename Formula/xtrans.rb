class Xtrans < Formula
  desc "X.Org: X Network Transport layer shared code"
  homepage "https://www.x.org/"
  url "https://www.x.org/archive/individual/lib/xtrans-1.5.0.tar.xz"
  sha256 "1ba4b703696bfddbf40bacf25bce4e3efb2a0088878f017a50e9884b0c8fb1bd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "9b83139171ea1c0b61f5d053e824f1be8715c28e7fe190a8784a1a6ea9234047"
  end

  depends_on "pkg-config" => :build
  depends_on "util-macros" => :build
  depends_on "xorgproto" => :test

  def install
    # macOS and Fedora systems do not provide stropts.h
    inreplace "Xtranslcl.c", "# include <stropts.h>", "# include <sys/ioctl.h>"

    system "./configure", *std_configure_args,
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}",
                          "--disable-silent-rules",
                          "--enable-docs=no"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "X11/Xtrans/Xtrans.h"

      int main(int argc, char* argv[]) {
        Xtransaddr addr;
        return 0;
      }
    EOS
    system ENV.cc, "./test.c", "-o", "test"
    system "./test"
  end
end
