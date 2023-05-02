class LibgeditGtksourceview < Formula
  desc "Text editor widget for code editing"
  homepage "https://gedit-technology.net"
  url "https://gedit-technology.net/tarballs/libgedit-gtksourceview/libgedit-gtksourceview-299.0.1.tar.xz"
  sha256 "74f8521b70a357708b08e2fdab28fb7796e0b67f6f8a7926a753b61cf3e9960b"
  license "LGPL-2.1-only"
  head "https://github.com/gedit-technology/libgedit-gtksourceview.git", branch: "main"

  depends_on "gobject-introspection" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "gtk+3"
  depends_on "libxml2" # Dependent `gedit` uses Homebrew `libxml2`

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--enable-introspection"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <gtksourceview/gtksource.h>

      int main(int argc, char *argv[]) {
        gchar *text = gtk_source_utils_unescape_search_text("hello world");
        return 0;
      }
    EOS
    flags = shell_output("pkg-config --cflags --libs libgedit-gtksourceview-300").strip.split
    system ENV.cc, "test.c", "-o", "test", *flags
    system "./test"
  end
end
