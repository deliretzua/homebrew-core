class GstDevtools < Formula
  include Language::Python::Shebang

  desc "GStreamer development and validation tools"
  homepage "https://gstreamer.freedesktop.org/modules/gstreamer.html"
  url "https://gstreamer.freedesktop.org/src/gst-devtools/gst-devtools-1.18.5.tar.xz"
  sha256 "fecffc86447daf5c2a06843c757a991d745caa2069446a0d746e99b13f7cb079"
  license "LGPL-2.1-or-later"
  head "https://gitlab.freedesktop.org/gstreamer/gst-devtools.git"

  livecheck do
    url "https://gstreamer.freedesktop.org/src/gst-devtools/"
    regex(/href=.*?gst-devtools[._-]v?(\d+\.\d*[02468](?:\.\d+)*)\.t/i)
  end

  bottle do
    sha256 arm64_big_sur: "8eb42ba8a37c3148ddb08bac4f6da532079cfd2b48f7a60fee705ba553eaa533"
    sha256 big_sur:       "c9112da83d65e0993e5b5ce4a87ae72e85093c57ad21c7b99e52a69cc36a8b1a"
    sha256 catalina:      "b01a80a014c19658e7a3d8b3a8f54db3f98bec9314ba887690b632a28b492fbb"
    sha256 mojave:        "4537802ab817fc7b4c74f9968363bec97aafdabc8439935fc905dc46dd473a60"
    sha256 x86_64_linux:  "af7aacdec2e3482c4a3592ae25f15e30f86cf022f0d82cecfb5c952346ccf349"
  end

  depends_on "gobject-introspection" => :build
  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "gettext"
  depends_on "gst-plugins-base"
  depends_on "gstreamer"
  depends_on "json-glib"
  depends_on "python@3.9"

  def install
    args = std_meson_args + %w[
      -Dintrospection=enabled
      -Dvalidate=enabled
      -Dtests=disabled
    ]

    mkdir "build" do
      system "meson", *args, ".."
      system "ninja", "-v"
      system "ninja", "install", "-v"
    end

    rewrite_shebang detected_python_shebang, bin/"gst-validate-launcher"
  end

  test do
    system "#{bin}/gst-validate-launcher", "--usage"
  end
end
