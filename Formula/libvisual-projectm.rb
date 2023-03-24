class LibvisualProjectm < Formula
  desc "Visualization plug-in for projectM support from Libvisual"
  homepage "https://github.com/projectM-visualizer/frontend-libvisual-plug-in"
  url "https://github.com/projectM-visualizer/frontend-libvisual-plug-in/archive/refs/tags/v2.1.1.tar.gz"
  sha256 "eb8269c2a923546600d3f40ff90c011f03a215847215ee8bef44bfae305b4dd7"
  license "GPL-3.0-or-later"

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "libvisual-plugins" => :test
  depends_on "xorg-server" => :test

  depends_on "libvisual"
  depends_on "projectm"

  def install
    # NOTE: We cannot write to libvisual's cellar, so we deflect
    #       installation and leverage brew's auto-symlinking
    #       to <HOMEBREW_PREFIX>/lib/libvisual-<major>.<minor>/actor .
    libvisual = Formula["libvisual"]
    inreplace "CMakeLists.txt",
      "LIBRARY DESTINATION \"${LIBVISUAL_ACTOR_PLUGINS_DIR}\"",
      "LIBRARY DESTINATION \"#{lib}/libvisual-#{libvisual.version.major_minor}/actor\""

    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
    doc.install "AUTHORS.md" => "AUTHORS"
  end

  test do
    libvisual = Formula["libvisual"]
    lv_tool = libvisual.bin/"lv-tool-#{libvisual.version.major_minor}"

    # Test that locating used plugins works properly
    plugin_help_output = shell_output("#{lv_tool} --plugin-help 2>&1")
    assert_match " (debug)", plugin_help_output
    assert_match " (projectM)", plugin_help_output

    # Tests that lv-tool starts up projectM without crashing
    xvfb_pid = fork do
      exec Formula["xorg-server"].bin/"Xvfb", ":1"
    end
    ENV["DISPLAY"] = ":1"

    lv_tool_pid = fork do
      # NOTE: The two lines "assertion `video != NULL' failed" in the output
      #       are to be expected and can be ignored.
      exec lv_tool, "--input", "debug", "--actor", "projectM"
    end

    sleep 5
  ensure
    Process.kill("SIGINT", lv_tool_pid)
    Process.wait(lv_tool_pid)

    Process.kill("SIGINT", xvfb_pid)
    Process.wait(xvfb_pid)
  end
end
