class Sdl2Mixer < Formula
  desc "Sample multi-channel audio mixer library"
  homepage "https://github.com/libsdl-org/SDL_mixer"
  url "https://github.com/libsdl-org/SDL_mixer/releases/download/release-2.6.3/SDL2_mixer-2.6.3.tar.gz"
  sha256 "7a6ba86a478648ce617e3a5e9277181bc67f7ce9876605eea6affd4a0d6eea8f"
  license "Zlib"

  # This formula uses a file from a GitHub release, so we check the latest
  # release version instead of Git tags.
  livecheck do
    url :stable
    strategy :github_latest
    regex(%r{href=.*?/tag/release[._-]v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "87aacc15b9b3f376868ae010adf45fc77c9e8ea225f005b00e2f9e8e628dbe80"
    sha256 cellar: :any,                 arm64_monterey: "04cf6823246e7db7b7732b50b2a22ccb52260cb4fad7500e1919744112098859"
    sha256 cellar: :any,                 arm64_big_sur:  "794648b3c66dbd4d3eafb8657e3236fb2e11209000e16fde24758481d19577c0"
    sha256 cellar: :any,                 ventura:        "1ac0fca1270e608ee716c9861e2ebfc5e9bed8b19fc92611dd0173276475be5e"
    sha256 cellar: :any,                 monterey:       "5dd18dc4715a34882435d4f9cf9fbadcaa437bdfd3139fa4262fe34c7cc467bd"
    sha256 cellar: :any,                 big_sur:        "0c27a68d5a7918dcfb9c3fbff4f49439bf44566fb24bfad531143db831c2bf4d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68898214e734c6c85a3a1589575dec299550435db9c224d352fdb9b86955e59b"
  end

  head do
    url "https://github.com/libsdl-org/SDL_mixer.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "flac"
  depends_on "libmodplug"
  depends_on "libvorbis"
  depends_on "mpg123"
  depends_on "sdl2"

  def install
    inreplace "SDL2_mixer.pc.in", "@prefix@", HOMEBREW_PREFIX

    if build.head?
      mkdir "build"
      system "./autogen.sh"
    end

    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --enable-music-flac
      --disable-music-flac-shared
      --disable-music-midi-fluidsynth
      --disable-music-midi-fluidsynth-shared
      --disable-music-mod-mikmod-shared
      --disable-music-mod-modplug-shared
      --disable-music-mp3-mpg123-shared
      --disable-music-ogg-shared
      --enable-music-mod-mikmod
      --enable-music-mod-modplug
      --enable-music-ogg
      --enable-music-mp3-mpg123
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <SDL2/SDL_mixer.h>

      int main()
      {
          int success = Mix_Init(0);
          Mix_Quit();
          return success;
      }
    EOS
    system ENV.cc, "-I#{Formula["sdl2"].opt_include}/SDL2",
           "test.c", "-L#{lib}", "-lSDL2_mixer", "-o", "test"
    system "./test"
  end
end
