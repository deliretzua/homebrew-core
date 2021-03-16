class KyotoCabinet < Formula
  desc "Library of routines for managing a database"
  homepage "https://fallabs.com/kyotocabinet/"
  url "https://fallabs.com/kyotocabinet/pkg/kyotocabinet-1.2.79.tar.gz"
  sha256 "67fb1da4ae2a86f15bb9305f26caa1a7c0c27d525464c71fd732660a95ae3e1d"
  license "GPL-3.0-or-later"

  bottle do
    sha256 arm64_big_sur: "1ca68b35195efd332074aeee92585a14d4dd1b4f54e1d5b398c3b74429c00329"
    sha256 big_sur:       "d378396d5ea0974ddcd3fa105618bfb826da0f5280b2310a64d85f7bb570cf91"
    sha256 catalina:      "444a9c86b36b081cc9ad31ef68d8c4e03f0861b9f0603a7fe5c99780cdab3926"
    sha256 mojave:        "ddd2f1b0f1985ad81b04b29dbd54f95c5f7c88f7427b559e9f298a6473a820b0"
    sha256 high_sierra:   "e4b99c22b5aebf85986e5c172ec61768833708acbb04318335f6641bea1f77ef"
    sha256 sierra:        "04ef198a6638dabdee27e881df9b16970eadc724f2f663a01edee7950b38b85a"
  end

  uses_from_macos "zlib"

  patch :DATA

  def install
    ENV.cxx11
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make" # Separate steps required
    system "make", "install"
  end
end


__END__
--- a/kccommon.h  2013-11-08 09:27:37.000000000 -0500
+++ b/kccommon.h  2013-11-08 09:27:47.000000000 -0500
@@ -82,7 +82,7 @@
 using ::snprintf;
 }

-#if __cplusplus > 199711L || defined(__GXX_EXPERIMENTAL_CXX0X__) || defined(_MSC_VER)
+#if __cplusplus > 199711L || defined(__GXX_EXPERIMENTAL_CXX0X__) || defined(_MSC_VER) || defined(_LIBCPP_VERSION)

 #include <unordered_map>
 #include <unordered_set>
