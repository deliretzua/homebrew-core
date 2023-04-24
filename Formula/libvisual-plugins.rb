class LibvisualPlugins < Formula
  desc "Audio Visualization tool and library"
  homepage "https://github.com/Libvisual/libvisual"
  url "https://github.com/Libvisual/libvisual/releases/download/libvisual-plugins-0.4.2/libvisual-plugins-0.4.2.tar.gz"
  sha256 "55988403682b180d0de5e6082f804f3cf066d9a08e887b10eb6a315eb40d9f87"
  license all_of: ["GPL-2.0-or-later", "GPL-3.0-or-later", "LGPL-2.1-or-later"]

  depends_on "pkg-config" => :build
  depends_on "xorg-server" => :test

  depends_on "jack"
  depends_on "libvisual"
  depends_on "portaudio"
  depends_on "sdl12-compat"

  uses_from_macos "bison" => :build

  on_linux do
    depends_on "alsa-lib"
    depends_on "mesa"
    depends_on "mesa-glu"
    depends_on "pulseaudio"
  end

  def install
    libvisual = Formula["libvisual"]
    configure_args = [
      "--disable-gdkpixbuf-plugin",
      "--disable-gforce",
      "--disable-gstreamer-plugin",
      # NOTE: This relies on brew's auto-symlinking to
      #       <HOMEBREW_PREFIX>/lib/libvisual-<major>.<minor> .
      "--with-plugins-base-dir=#{lib}/libvisual-#{libvisual.version.major_minor}",
    ]
    system "./configure", *configure_args, *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    libvisual = Formula["libvisual"]
    lv_tool = libvisual.bin/"lv-tool-#{libvisual.version.major_minor}"

    # Test that locating key plugins works properly
    plugin_help_output = shell_output("#{lv_tool} --plugin-help 2>&1")
    assert_match " (debug)", plugin_help_output
    assert_match " (lv_gltest)", plugin_help_output
    assert_match " (portaudio)", plugin_help_output

    # Tests that lv-tool starts up without crashing
    xvfb_pid = fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"

    lv_tool_pid = fork do
      # NOTE: The two lines "assertion `video != NULL' failed" in the output
      #       are to be expected and can be ignored.
      exec lv_tool, "--input", "debug"
    end

    sleep 5
  ensure
    Process.kill("SIGINT", lv_tool_pid)
    Process.wait(lv_tool_pid)

    Process.kill("SIGINT", xvfb_pid)
    Process.wait(xvfb_pid)
  end
end
