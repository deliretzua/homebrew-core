class DsdaDoom < Formula
  desc "Fork of prboom+ with a focus on speedrunning"
  homepage "https://github.com/kraflab/dsda-doom"
  url "https://github.com/kraflab/dsda-doom/archive/refs/tags/v0.25.2.tar.gz"
  sha256 "e030491e4cb7ade1d297164d95286fc1853bb08b2077397cbb4a46c4869b3280"
  license "GPL-2.0-only"
  head "https://github.com/kraflab/dsda-doom.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_ventura:  "e60c8a68c589b08d71e9eec7d9058193522d3ab2384d2755237f9264f0212c36"
    sha256 arm64_monterey: "62038cc4843ab6f92f3b75fa127e235785028871e30d62dca7e2bb5e4782121c"
    sha256 arm64_big_sur:  "d84c1e34f2349ef0610946840da0a436a4041157d9aec9ed31f46cf6684ef751"
    sha256 ventura:        "5db8e8159164e8055ba2c4b4611603e67d8ab84f040e8220adce2d2b5f408e9b"
    sha256 monterey:       "3e5cbaa5e04a329ace50b5645e3f6cf6a4c7ebf7aa1a71ac48b9c722842a8c3d"
    sha256 big_sur:        "ccb785432305e5cc4dc82c42e581dfac52a4c05c7a6483dd02dbfe8c1f9c0a30"
    sha256 x86_64_linux:   "2b4f37f1ddf0d2409b7ff9d395facab941eddecd0aed123bb1e26f5df446b770"
  end

  depends_on "cmake" => :build
  depends_on "fluid-synth"
  depends_on "libvorbis"
  depends_on "mad"
  depends_on "pcre"
  depends_on "portmidi"
  depends_on "sdl2"
  depends_on "sdl2_image"
  depends_on "sdl2_mixer"
  uses_from_macos "zlib"

  on_linux do
    depends_on "mesa-glu"
  end

  def doomwaddir(root)
    root/"share/games/doom"
  end

  def install
    system "cmake", "-S", "prboom2", "-B", "build",
                    "-DDOOMWADDIR=#{doomwaddir(HOMEBREW_PREFIX)}",
                    "-DDSDAPWADDIR=#{libexec}",
                    "-DBUILD_GL=ON",
                    "-DWITH_DUMB=OFF",
                    "-DWITH_IMAGE=ON",
                    "-DWITH_FLUIDSYNTH=ON",
                    "-DWITH_MAD=ON",
                    "-DWITH_PCRE=ON",
                    "-DWITH_PORTMIDI=ON",
                    "-DWITH_VORBISFILE=ON",
                    "-DWITH_ZLIB=ON",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  def post_install
    doomwaddir(HOMEBREW_PREFIX).mkpath
  end

  def caveats
    <<~EOS
      For DSDA-Doom to find your WAD files, place them in:
        #{doomwaddir(HOMEBREW_PREFIX)}
    EOS
  end

  test do
    expected_output = "dsda-doom v#{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/dsda-doom -iwad invalid_wad 2>&1", 255)
  end
end
