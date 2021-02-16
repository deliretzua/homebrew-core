class Xkeyboardconfig < Formula
  desc "Keyboard configuration database for the X Window System"
  homepage "https://www.freedesktop.org/wiki/Software/XKeyboardConfig/"
  url "https://xorg.freedesktop.org/archive/individual/data/xkeyboard-config/xkeyboard-config-2.32.tar.bz2"
  sha256 "1feee317ba39b91902b0cbd2987c0c73e6afbfc8f4c096367a5c86c216c036a8"
  license "MIT"
  head "https://gitlab.freedesktop.org/xkeyboard-config/xkeyboard-config.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "ed5f4d5be9381ef91eadba64cf368ab3e4b0e7d490a5b472097c8671a837e83b"
    sha256 cellar: :any_skip_relocation, big_sur:       "5d2d8508d8ea7a1aeb33520285088526d460f3e796911bde60af52e0fee0cab7"
    sha256 cellar: :any_skip_relocation, catalina:      "657ec08d8201cd932171f8f9acecd94e62f66657ea7c730810fb2dec70e17c1f"
    sha256 cellar: :any_skip_relocation, mojave:        "20a9ec45d3b7fbeca4dfd3bef4dff0108e7ed2481a2b3256c0dd4f152b996de5"
  end

  depends_on "gettext" => :build
  depends_on "intltool" => :build
  depends_on "pkg-config" => [:build, :test]
  depends_on "python@3.9" => :build
  uses_from_macos "libxslt" => :build

  def install
    # Needed by intltool (xml::parser)
    ENV.prepend_path "PERL5LIB", "#{Formula["intltool"].libexec}/lib/perl5"

    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
      --with-xkb-rules-symlink=xorg
      --disable-runtime-deps
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    assert_predicate man7/"xkeyboard-config.7", :exist?
    assert_equal "#{share}/X11/xkb", shell_output("pkg-config --variable=xkb_base xkeyboard-config").chomp
    assert_match "Language: en_GB", shell_output("strings #{share}/locale/en_GB/LC_MESSAGES/xkeyboard-config.mo")
  end
end
