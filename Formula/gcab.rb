class Gcab < Formula
  desc "Windows installer (.MSI) tool"
  homepage "https://wiki.gnome.org/msitools"
  url "https://download.gnome.org/sources/gcab/1.6/gcab-1.6.tar.xz"
  sha256 "2f0c9615577c4126909e251f9de0626c3ee7a152376c15b5544df10fc87e560b"
  license "LGPL-2.1-or-later"

  # We use a common regex because gcab doesn't use GNOME's "even-numbered minor
  # is stable" version scheme.
  livecheck do
    url :stable
    regex(/gcab[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "1d0df9fc71f98941abf94db41da7453d3c110f1ad1d9d68531562236c248c31b"
    sha256 arm64_monterey: "e49e15cd9661987efd99db61dc29b244a8f9459a3bcaeba342b37c04ab31a555"
    sha256 arm64_big_sur:  "731d488b6e811c7c98feae0dd58956ae982710ab839be34a2d875adeb8b17218"
    sha256 ventura:        "28ba70d27ac7f93e0a26daf48e1b58a4305b4c4ba250145d774590e0fd5867bc"
    sha256 monterey:       "bc78f61070ee0ad6a4397db82e661d89b76b17f8217401dbdc82e76742f7deee"
    sha256 big_sur:        "e0ddb5aee18997830d3b55772a1deaaf93a8b6a488a5bc68b4188a69dedbc5ea"
    sha256 catalina:       "431ec9816bf99b859a17367933fa11e2c43498078dc423d4b759575ee1a2cbc3"
    sha256 x86_64_linux:   "d31fd6fd578719a656cc13e05570257bfc9dd0ecb057cf1a003561a5c202443b"
  end

  depends_on "gettext" => :build
  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "vala" => :build
  depends_on "glib"

  def install
    system "meson", "setup", "build", "-Ddocs=false", "-Dtests=false", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system "#{bin}/gcab", "--version"
  end
end
