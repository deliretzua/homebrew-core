class DosboxX < Formula
  desc "DOSBox with accurate emulation and wide testing"
  homepage "https://dosbox-x.com/"
  url "https://github.com/joncampbell123/dosbox-x/archive/refs/tags/dosbox-x-v2023.05.01.tar.gz"
  sha256 "0aa75b873978aec41ecfee62bb103d8a17fe3566a3ebf5415245cee0dd032ebb"
  license "GPL-2.0-or-later"
  version_scheme 1
  head "https://github.com/joncampbell123/dosbox-x.git", branch: "master"

  livecheck do
    url "https://github.com/joncampbell123/dosbox-x/releases?q=prerelease%3Afalse"
    regex(%r{href=["']?[^"' >]*?/tag/dosbox-x[._-]v?(\d+(?:\.\d+)+)["' >]}i)
    strategy :page_match
  end

  bottle do
    sha256 arm64_ventura:  "00c26ae6b3e97d06df10b334ad193abc75466b91c6d527c6aff5aab92b58a4e1"
    sha256 arm64_monterey: "a169031430a88bad5312283238b080e0ee2dfbcf284941058ea0bdce31fe8813"
    sha256 arm64_big_sur:  "b303d6e812501804ba5caf6d1fd364a1fb2a62a963cacf09ee2f9aafeb13c839"
    sha256 ventura:        "458904df51fc377a6a278811c234103e0e496e9ff75e58a89a7a5d74f28b4a34"
    sha256 monterey:       "ca8d44dd42b5fac944fc1abad07869f22525d99693320af4e9c50e30a4c804ce"
    sha256 big_sur:        "7bd26791e1fda10eca74df923d73e13e84330b38293abe1a744d546ac1f149d1"
    sha256 x86_64_linux:   "8cec915aab35a629cc7e32388f36a86feae9d12dcfda6ce75184536bf24b29a1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "fluid-synth"
  depends_on "freetype"
  depends_on "libpng"
  depends_on "libslirp"
  depends_on macos: :high_sierra # needs futimens
  depends_on "sdl2"
  uses_from_macos "zlib"

  on_linux do
    depends_on "linux-headers@5.15" => :build
  end

  fails_with gcc: "5"

  def install
    ENV.cxx11

    # See flags in `build-macos-sdl2`.
    args = %w[
      --enable-core-inline
      --enable-sdl2
      --disable-sdl2test
      --disable-sdl
      --disable-sdltest
    ]

    system "./autogen.sh"
    system "./configure", *std_configure_args, *args
    system "make" # Needs to be called separately from `make install`.
    system "make", "install"
  end

  test do
    assert_match "DOSBox-X version #{version}", shell_output("#{bin}/dosbox-x -version 2>&1", 1)
  end
end
