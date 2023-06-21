class WoofDoom < Formula
  desc "Woof! is a continuation of the Boom/MBF bloodline of Doom source ports"
  homepage "https://github.com/fabiangreffrath/woof"
  url "https://github.com/fabiangreffrath/woof/archive/refs/tags/woof_11.3.0.tar.gz"
  sha256 "3035b5d4d174f57067afa30721a5f1ba978a01ffa173e6a6bf691ee3cc4355fc"
  license "GPL-2.0-only"

  depends_on "cmake" => :build
  depends_on "fluid-synth"
  depends_on "libsndfile"
  depends_on "libxmp"
  depends_on "openal-soft"
  depends_on "sdl2"
  depends_on "sdl2_net"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    expected_output = "Woof #{version.major_minor_patch}"
    assert_match expected_output, shell_output("#{bin}/woof -iwad -nogui invalid_wad 2>&1", 255)
  end
end
