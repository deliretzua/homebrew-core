class Newsboat < Formula
  desc "RSS/Atom feed reader for text terminals"
  homepage "https://newsboat.org/"
  url "https://newsboat.org/releases/2.23/newsboat-2.23.tar.xz"
  sha256 "b997b139d41db2cc5f54346f27c448bee47d6c6228a12ce9cb91c3ffaec7dadc"
  license "MIT"
  head "https://github.com/newsboat/newsboat.git"

  bottle do
    sha256 arm64_big_sur: "e9fcc698d8778d553246fb3d1bf53976818e59376c56e3c28bdc041f34526a6c"
    sha256 big_sur:       "5f662f131861dd00d6f25122f7f790e6db3a6a8769406ef5740b55f061f8ec24"
    sha256 catalina:      "180667d4eb94c77f4fbc43e542b823fccbd91b020e341a5fa132d4789d105c49"
    sha256 mojave:        "bbf2e67497c2c4985401be6d13effd2794ed2619e2a2cbdb014e30f98faa3830"
  end

  depends_on "asciidoctor" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "gettext"
  depends_on "json-c"
  depends_on "libstfl"

  uses_from_macos "curl"
  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  def install
    gettext = Formula["gettext"]

    ENV["GETTEXT_BIN_DIR"] = gettext.opt_bin.to_s
    ENV["GETTEXT_LIB_DIR"] = gettext.lib.to_s
    ENV["GETTEXT_INCLUDE_DIR"] = gettext.include.to_s
    ENV["XML_CATALOG_FILES"] = etc/"xml/catalog"

    system "make", "install", "prefix=#{prefix}"
  end

  test do
    (testpath/"urls.txt").write "https://github.com/blog/subscribe"
    assert_match "newsboat - Exported Feeds", shell_output("LC_ALL=C #{bin}/newsboat -e -u urls.txt")
  end
end
