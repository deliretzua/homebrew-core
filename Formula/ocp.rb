class Ocp < Formula
  desc "UNIX port of the Open Cubic Player"
  homepage "https://stian.cubic.org/project-ocp.php"
  url "https://stian.cubic.org/ocp/ocp-0.2.104.tar.xz"
  sha256 "e07dce02c3e72233a82903a670d392dac0f6b082ed4d4a72eddd9da48ef77b8b"
  license "GPL-2.0-or-later"
  head "https://github.com/mywave82/opencubicplayer.git", branch: "master"

  livecheck do
    url :homepage
    regex(/href=.*?ocp[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c7ca36aa0c6454dd1f81e8e14a423465c51a77352e40f5504da636afc82541b1"
    sha256 arm64_monterey: "8281c50015ce281c42737566047f8067d3cc30f973b9d5719bd1c2045b84f705"
    sha256 arm64_big_sur:  "dc2d44a29374c9b486fe34fd7da877d5bf95c5e7c826c1639ee3b433763d18f4"
    sha256 ventura:        "43de7f95a135e2d6a162a91a70ec85618b0ade0e5874999a2fbc52793e4e3008"
    sha256 monterey:       "5a658ff7cfc819108c2a9da564f12269a760a8dd95a55aaf38c38946eef03b45"
    sha256 big_sur:        "3753e014db06bbacda637ecfea2db9ca3730e31e81ef543a09c0032a4537cf56"
    sha256 x86_64_linux:   "d63ae73b95e1be93b2b684db74c08a056dcd995dcfdc42c7d01cc6bc0d786f25"
  end

  depends_on "pkg-config" => :build
  depends_on "xa" => :build
  depends_on "ancient"
  depends_on "cjson"
  depends_on "flac"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libdiscid"
  depends_on "libpng"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "sdl2"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  resource "unifont" do
    url "https://ftp.gnu.org/gnu/unifont/unifont-15.0.01/unifont-15.0.01.tar.gz"
    sha256 "7d11a924bf3c63ea7fdf2da2b96d6d4986435bedfd1e6816c8ac2e6db47634d5"
  end

  # patch for clockid_t redefinition issue
  patch do
    url "https://github.com/mywave82/opencubicplayer/commit/6ad481d04cf34f29755b12aac9e9e3c046cfe764.patch?full_index=1"
    sha256 "85943335fe93e577ef42c427f32b9a3759ec52beed86930e289205b2f5a30d1a"
  end

  # Remove a redundant semicolon.
  # Sent upstream at https://github.com/mywave82/opencubicplayer/pull/100.
  patch do
    url "https://github.com/mywave82/opencubicplayer/commit/907bb7aeba27a1b64e9ac4942aa144f216f5eded.patch?full_index=1"
    sha256 "c6cc5d011601615657455a1a65d86fe7680a664a1a14fa0d6007ca628eb89f8d"
  end

  def install
    ENV.deparallelize

    # Required for SDL2
    resource("unifont").stage do |r|
      cd "font/precompiled" do
        share.install "unifont-#{r.version}.ttf" => "unifont.ttf"
        share.install "unifont_csur-#{r.version}.ttf" => "unifont_csur.ttf"
        share.install "unifont_upper-#{r.version}.ttf" => "unifont_upper.ttf"
      end
    end

    args = %W[
      --prefix=#{prefix}
      --without-x11
      --without-desktop_file_install
      --without-update-mime-database
      --without-update-desktop-database
      --with-unifontdir-ttf=#{share}
      --with-unifontdir-otf=#{share}
    ]

    system "./configure", *args
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/ocp", "--help"
  end
end
