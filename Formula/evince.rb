class Evince < Formula
  desc "GNOME document viewer"
  homepage "https://wiki.gnome.org/Apps/Evince"
  url "https://download.gnome.org/sources/evince/40/evince-40.3.tar.xz"
  sha256 "23203820026a3acebe923bc784bb7e46213f91a2919419609f372f9fc34e387f"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "0dc6fbdb1feba692a69d2e622efff3708709129ff8a274e00d0ad0c1dd263641"
    sha256 big_sur:       "c688724a9ee9f2580566bc64ed1d98bae5c6a0c3926d4ebd89213863764c804b"
    sha256 catalina:      "bc0a8a9978a6d278ddac4e4f8314c9439f72b905e8c35c4442989a9c007798ef"
    sha256 mojave:        "3b9f0701893aceb56079a8b648828ee943bf76d7a90e7371937e2210b7fc3777"
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

  # patch submitted upstream
  # see https://gitlab.gnome.org/GNOME/evince/-/merge_requests/348
  patch do
    url "https://gitlab.gnome.org/GNOME/evince/-/commit/5d08585702b6dfccc67098b501cfa99a01775c87.diff"
    sha256 "87dd01dcf68ddee832cc9931165bc8dd66c76cb09520072afd0354b02b600146"
  end

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
