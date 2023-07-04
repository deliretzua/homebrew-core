class Libisofs < Formula
  desc "Library to create an ISO-9660 filesystem with various extensions"
  homepage "https://dev.lovelyhq.com/libburnia/libisofs"
  url "https://files.libburnia-project.org/releases/libisofs-1.5.6.pl01.tar.gz"
  version "1.5.6"
  sha256 "ac1fd338d641744ca1fb1567917188b79bc8c2506832dd56885fec98656b9f25"
  license "GPL-2.0-or-later"

  livecheck do
    url "https://files.libburnia-project.org/releases/"
    regex(/href=.*?libisofs[._-]v?(\d+(?:\.\d+)+)(?:[._-]pl\d+)?\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "860314162c48e96a989ba3fb787d2049ca42cfbfbf0b5300efe1dc0fd78868a9"
    sha256 cellar: :any,                 arm64_monterey: "a0ef9a6c528dc64cb52cf715e32bf3eea4163a87c622896380a545cbf3a15a9a"
    sha256 cellar: :any,                 arm64_big_sur:  "a5aa2cc2315f882bc5845478bc6e804058fe91552b7bf0dcad61f94b41e762bf"
    sha256 cellar: :any,                 ventura:        "25ea2064b42c23129e06205029b7d7d05f8db51f8c17ee901166ceb49c15d6e2"
    sha256 cellar: :any,                 monterey:       "24d410d388e6a034b5a2e065347287aa961fbe85ca3b7d5a1ffa9c1a50d2cbdf"
    sha256 cellar: :any,                 big_sur:        "129cda4e83bf47b6d03a9fd742c2dea43d38b21a716ffc289fead5b2d081ae05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "aaa4498b356521663380cbd57be5e28574a18854a35f7da734a3d96469df5cf8"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool"  => :build
  depends_on "libzip"

  def install
    # use gnu libtool instead of apple libtool
    inreplace "bootstrap", "libtool", "glibtool"
    # regenerate configure as release uses old version of libtool
    # which causes flat_namespace
    system "./bootstrap"

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdint.h>
      #include <libisofs/libisofs.h>

      int main() {
        int major, minor, micro;
        iso_lib_version(&major, &minor, &micro);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-I#{include}", "-lisofs", "-o", "test"
    system "./test"
  end
end
