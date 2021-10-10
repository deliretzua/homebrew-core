class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/41/evince-41.2.tar.xz"
  sha256 "95abad0d6feeac9560db3ab80ba7c5eabb1fdf1ca0e3b3c93339af05453a24d8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "7bcff96196c46ad557adeeb2be2f193b0e95318061b38af98016da22d139660e"
    sha256 big_sur:       "ccfb45a66914208ee9081fa7d739e4ee7cc1bc770f58b1b3bc04399bcf180e1a"
    sha256 catalina:      "6dc1d3ed7de3c811f6bf8ed5005da746cf1c24218f34e15e7c9988f5352e9f23"
    sha256 mojave:        "87d28a7a1f63858dbd6055660557a038bc146e5912e6aa9cb01f08f09b7f5729"
  end

  depends_on "gobject-introspection" => :build
  depends_on "itstool" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "adwaita-icon-theme"
  depends_on "djvulibre"
  depends_on "gspell"
  depends_on "gtk+3"
  depends_on "hicolor-icon-theme"
  depends_on "libarchive"
  depends_on "libgxps"
  depends_on "libhandy"
  depends_on "libsecret"
  depends_on "libspectre"
  depends_on "poppler"
  depends_on "python@3.9"

  def install
    ENV["DESTDIR"] = "/"

    args = %w[
      -Dnautilus=false
      -Ddjvu=enabled
      -Dgxps=enabled
      -Dcomics=enabled
      -Dgtk_doc=false
      -Dintrospection=true
      -Dbrowser_plugin=false
      -Dgspell=enabled
      -Ddbus=false
      -Dps=enabled
    ]

    mkdir "build" do
      system "meson", *std_meson_args, *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end
  end

  def post_install
    system "#{Formula["glib"].opt_bin}/glib-compile-schemas", "#{HOMEBREW_PREFIX}/share/glib-2.0/schemas"
    system "#{Formula["gtk+3"].opt_bin}/gtk3-update-icon-cache", "-f", "-t", "#{HOMEBREW_PREFIX}/share/icons/hicolor"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/evince --version")
  end
end
