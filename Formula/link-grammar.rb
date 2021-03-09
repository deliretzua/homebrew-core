class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://www.abisource.com/projects/link-grammar/"
  url "https://www.abisource.com/downloads/link-grammar/5.8.1/link-grammar-5.8.1.tar.gz"
  sha256 "11c4ff551fa5169257dacc575080c63b075c790edac29984a94641a0993b505b"
  license "LGPL-2.1"

  livecheck do
    url :homepage
    regex(/href=.*?link-grammar[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "2ff86c07dc50539754a20b35fbd548c421f9822b39ab43053f2721ee6841fd43"
    sha256 big_sur:       "6416c4a870cf3a11a345ffc0d1fecfb64e402dc264648febe89c6b9cb903f514"
    sha256 catalina:      "d2125eec68c573874249d6b3629b54b9c55c7c378343f9ae969440dfdbb3497d"
    sha256 mojave:        "5c6e347b0c82683ae1a3c8838bec8bf9b840c06fbe33e59a494ea3495256b0e0"
    sha256 high_sierra:   "64a9aa4bebc23fe23063f436cd18bca518e11f3be4322ca60d2d710c9ed6cd8c"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.9" => :build

  uses_from_macos "sqlite"

  def install
    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am",
      "$(PYTHON_LDFLAGS) -module -no-undefined",
      "$(PYTHON_LDFLAGS) -module"
    inreplace "link-grammar/link-grammar.def", "regex_tokenizer_test\n", ""
    system "autoreconf", "-fiv"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-regexlib=c"
    system "make", "install"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
