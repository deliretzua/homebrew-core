class Libvisual < Formula
  desc "Audio Visualization tool and library"
  homepage "https://github.com/Libvisual/libvisual"
  url "https://github.com/Libvisual/libvisual/releases/download/libvisual-0.4.2/libvisual-0.4.2.tar.gz"
  sha256 "63085fd9835c42c9399ea6bb13a7ebd4b1547ace75c4595ce8e9759512bd998a"
  license all_of: ["GPL-2.0-or-later", "LGPL-2.1-or-later"]

  depends_on "pkg-config" => :build
  depends_on "sdl12-compat"

  def install
    # NOTE: Other formulae would not be able to install to libvisual's cellar
    #       so we rely on brew's auto-symlinking to
    #       <HOMEBREW_PREFIX>/lib/libvisual-<major>.<minor> .
    #       See libvisual-plugins.rb and/or libvisual-projectm.rb
    #       for how this is used by a formula installing libvisual plug-ins.
    inreplace "configure",
      "LIBVISUAL_PLUGINS_BASE_DIR=\"${libdir}/libvisual-${LIBVISUAL_VERSION_SUFFIX}\"",
      "LIBVISUAL_PLUGINS_BASE_DIR=\"#{HOMEBREW_PREFIX}/lib/libvisual-#{version.major_minor}\""

    system "./configure", *std_configure_args
    system "make"
    system "make", "install"
  end

  test do
    # NOTE: Without any plug-ins, there is no more that we could test.
    lv_tool = bin/"lv-tool-#{version.major_minor}"
    assert_match version.to_s, shell_output("#{lv_tool} --version")
  end
end
