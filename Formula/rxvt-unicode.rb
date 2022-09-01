class RxvtUnicode < Formula
  desc "Rxvt fork with Unicode support"
  homepage "http://software.schmorp.de/pkg/rxvt-unicode.html"
  url "http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.30.tar.bz2"
  sha256 "fe1c93d12f385876457a989fc3ae05c0915d2692efc59289d0f70fabe5b44d2d"
  license "GPL-3.0-only"

  livecheck do
    url "http://dist.schmorp.de/rxvt-unicode/"
    regex(/href=.*?rxvt-unicode[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "acaab9ae981de980c62c28e89072cf754e9cfce42c79179c8bf96ada884e006e"
    sha256 arm64_big_sur:  "2ad5cfb39d86aff0d7f3b785aee5058ce2b0bf113b13b24f963c1b8d60679ff3"
    sha256 monterey:       "e7fe499f09e78e5b61e12ceb8b910c44b643b10018bde3d390223e0643f32e38"
    sha256 big_sur:        "5e3a94dc348d57ada5dcb55eafee51b1ffa8bf78e10a8a2b0af9ac56b2d2ff02"
    sha256 catalina:       "b97c65d257344a16accd34497c77ec3638674c7c596b7f05c190d606975de9af"
    sha256 mojave:         "ecec482ad2b840b1cdb3945a42bcc31656d61a83ae3d08af2d2dafb1a4002d9d"
    sha256 x86_64_linux:   "33700270809fe7d85c106cc6ef8aeb0c85c053ea52f39e6124464cfbf01a8309"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "libx11"
  depends_on "libxft"
  depends_on "libxmu"
  depends_on "libxrender"
  depends_on "libxt"

  uses_from_macos "perl"

  resource "libptytty" do
    url "http://dist.schmorp.de/libptytty/libptytty-2.0.tar.gz"
    sha256 "8033ed3aadf28759660d4f11f2d7b030acf2a6890cb0f7926fb0cfa6739d31f7"
  end

  # Patches 1 and 2 remove -arch flags for compiling perl support
  # Patch 3 fixes `make install` target on case-insensitive filesystems
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/85fa66a9/rxvt-unicode/9.22.patch"
    sha256 "a266a5776b67420eb24c707674f866cf80a6146aaef6d309721b6ab1edb8c9bb"
  end

  def install
    ENV.cxx11
    resource("libptytty").stage do
      system "cmake", "-S", ".", "-B", "build", *std_cmake_args(install_prefix: buildpath), "-DBUILD_SHARED_LIBS=OFF"
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end
    ENV.prepend_path "PKG_CONFIG_PATH", buildpath/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-L#{buildpath}/lib"

    args = %W[
      --prefix=#{prefix}
      --enable-256-color
      --with-term=rxvt-unicode-256color
      --with-terminfo=/usr/share/terminfo
      --enable-smart-resize
      --enable-unicode3
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    daemon = fork do
      system bin/"urxvtd"
    end
    sleep 2
    system bin/"urxvtc", "-k"
    Process.wait daemon
  end
end
