class Hashcat < Formula
  desc "World's fastest and most advanced password recovery utility"
  homepage "https://hashcat.net/hashcat/"
  url "https://hashcat.net/files/hashcat-6.2.5.tar.gz"
  mirror "https://github.com/hashcat/hashcat/archive/v6.2.5.tar.gz"
  sha256 "6f6899d7ad899659f7b43a4d68098543ab546d2171f8e51d691d08a659378969"
  license "MIT"
  revision 1
  version_scheme 1
  head "https://github.com/hashcat/hashcat.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?hashcat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "d3ad60ae56bebbf00bd3717694899fd71a5f722cb848e1c555da7da1a4a23877"
    sha256 arm64_big_sur:  "b2588f27613a40648587cd20eea4e1c91cdb5fb30a5b9fde7bd768862bb393c4"
    sha256 monterey:       "53fd4349f2026bea928aa771a355ef003d15e58a04fc2f3d1516148e9b13b8b2"
    sha256 big_sur:        "241b1fce035f7aec87d216733c6c317345e17acfd423b5b991c5b27a18dde435"
    sha256 catalina:       "ce02a7f928c64a0ea397d60272ea0156f49ea1012c0bcf49608f53d7f0df0473"
    sha256 x86_64_linux:   "5fef95ceec066e31d3fa137827c1338fc728aa1bfe6059e1978797bb19dcd477"
  end

  depends_on "gnu-sed" => :build
  depends_on "minizip"
  depends_on "xxhash"

  uses_from_macos "zlib"

  on_linux do
    depends_on "opencl-headers" => :build
    depends_on "ocl-icd"
    depends_on "pocl"
  end

  # Fix build failure from missing include for limits.h.
  # Upstreamed here: https://github.com/hashcat/hashcat/pull/3387
  patch :DATA

  def install
    args = %W[
      CC=#{ENV.cc}
      PREFIX=#{prefix}
      USE_SYSTEM_XXHASH=1
      USE_SYSTEM_OPENCL=1
      USE_SYSTEM_ZLIB=1
      ENABLE_UNRAR=0
    ]
    system "make", *args
    system "make", "install", *args
  end

  test do
    ENV["XDG_DATA_HOME"] = testpath
    ENV["XDG_CACHE_HOME"] = testpath
    cp_r pkgshare.children, testpath
    cp bin/"hashcat", testpath
    system testpath/"hashcat --benchmark -m 0 -D 1,2 -w 2"
  end
end

__END__
diff --git a/src/filehandling.c b/src/filehandling.c
index 345d451..05baae9 100644
--- a/src/filehandling.c
+++ b/src/filehandling.c
@@ -5,6 +5,7 @@
 
 #include "common.h"
 #include "types.h"
+#include "limits.h"
 #include "memory.h"
 #include "shared.h"
 #include "filehandling.h"
