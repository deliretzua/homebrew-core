class Mpv < Formula
  desc "Media player based on MPlayer and mplayer2"
  homepage "https://mpv.io"
  url "https://github.com/mpv-player/mpv/archive/refs/tags/v0.35.1.tar.gz"
  sha256 "41df981b7b84e33a2ef4478aaf81d6f4f5c8b9cd2c0d337ac142fc20b387d1a9"
  license :cannot_represent
  head "https://github.com/mpv-player/mpv.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "68bf624f6b6225aff7a18e7ebf133f6a2f0d81227a1a9122e327c8df980f1186"
    sha256 arm64_monterey: "796101aafdfcab4e4e583b106913f2a6eaa9ec457b59231d3474f44564930d77"
    sha256 arm64_big_sur:  "d3c50d2df9634d918459aac2b48203f203efdc1e2b7ec385db54186c7923074f"
    sha256 ventura:        "84bd369996a53ea59179b0388074b89acdacf8b67ecc9858d4d67e9bb8677872"
    sha256 monterey:       "4bf17644be73ef2e0b5d9029a73ccbab14e46f8af6f331ae5ef5329b33be4ab5"
    sha256 big_sur:        "a7ede2a10b6bc0b59d980f5d731a221fdd0dc450fd909e594e8c877031e72a7f"
    sha256 catalina:       "9b4b79cfceb6ed515080e7094fcb3361dab288ba4541f7d9f0ea9176d34a6445"
    sha256 x86_64_linux:   "9123423529705479772f97524aff7c8a6536733ca47d3c823c7c0b7cbdb1db94"
  end

  depends_on "docutils" => :build
  depends_on "meson" => :build
  depends_on "pkg-config" => :build
  depends_on xcode: :build
  depends_on "ffmpeg"
  depends_on "jpeg-turbo"
  depends_on "libarchive"
  depends_on "libass"
  depends_on "little-cms2"
  depends_on "luajit"
  depends_on "mujs"
  depends_on "uchardet"
  depends_on "vapoursynth"
  depends_on "yt-dlp"

  on_linux do
    depends_on "alsa-lib"
  end

  def install
    # LANG is unset by default on macOS and causes issues when calling getlocale
    # or getdefaultlocale in docutils. Force the default c/posix locale since
    # that's good enough for building the manpage.
    ENV["LC_ALL"] = "C"

    # force meson find ninja from homebrew
    ENV["NINJA"] = Formula["ninja"].opt_bin/"ninja"

    # libarchive is keg-only
    ENV.prepend_path "PKG_CONFIG_PATH", Formula["libarchive"].opt_lib/"pkgconfig"

    args = %W[
      -Dhtml-build=enabled
      -Djavascript=enabled
      -Dlibmpv=true
      -Dlua=luajit
      -Dlibarchive=enabled
      -Duchardet=enabled
      --sysconfdir=#{pkgetc}
      --datadir=#{pkgshare}
      --mandir=#{man}
    ]

    system "meson", "setup", "build", *args, *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
  end

  test do
    system bin/"mpv", "--ao=null", "--vo=null", test_fixtures("test.wav")
    assert_match "vapoursynth", shell_output(bin/"mpv --vf=help")
  end
end
