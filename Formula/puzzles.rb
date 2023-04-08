class Puzzles < Formula
  desc "Collection of one-player puzzle games"
  homepage "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/"
  # Extract https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles.tar.gz to get the version number
  url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/puzzles-20230407.3b9cafa.tar.gz"
  version "20230407"
  sha256 "5236e975a525f2ba6c62dd4a57061e69d08d82b3f8c663346dea22ea4e3a4913"
  license "MIT"
  head "https://git.tartarus.org/simon/puzzles.git", branch: "main"

  # There's no directory listing page and the homepage only lists an unversioned
  # tarball. The Git repository doesn't report any tags when we use that. The
  # version in the footer of the first-party documentation seems to be the only
  # available source that's up to date (as of writing).
  livecheck do
    url "https://www.chiark.greenend.org.uk/~sgtatham/puzzles/doc/"
    regex(/version v?(\d{6,8})(?:\.[a-z0-9]+)?/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "322d253a85194998eb6737a4402a48f06d056b37cb438ba107bb228f812be9d0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0996cdbb7ea113d5a299e48fe067e045e59748410be6e2bf54d8729406e3738"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f98963a9659e179da1b6a12a5f4ff46f048e5d71ca470770b325272a5e590a8"
    sha256 cellar: :any_skip_relocation, ventura:        "433b01a9685caa0cb91535f8bf1f12f1de6cd6152564f2cc3af3617fdaf9429d"
    sha256 cellar: :any_skip_relocation, monterey:       "79028db77296c8d13ae56e8ec03f51f51be7164629f6cd439f9dd2f0c52a455b"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5433d4f5d36f89580eaed1090a7cb6821b087443ef8a11eb72b2d0b83695aee"
    sha256                               x86_64_linux:   "43c30424b863f071091a4c9b1250c4aa373c1e47c114019ecc69ecc2173d5583"
  end

  depends_on "cmake" => :build
  depends_on "halibut" => :build

  on_linux do
    depends_on "imagemagick" => :build
    depends_on "pkg-config" => :build
    depends_on "cairo"
    depends_on "gdk-pixbuf"
    depends_on "glib"
    depends_on "gtk+3"
    depends_on "pango"
  end

  conflicts_with "samba", because: "both install `net` binaries"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"

    bin.write_exec_script prefix/"Puzzles.app/Contents/MacOS/Puzzles" if OS.mac?
  end

  test do
    if OS.mac?
      assert_predicate prefix/"Puzzles.app/Contents/MacOS/Puzzles", :executable?
    else
      return if ENV["HOMEBREW_GITHUB_ACTIONS"]

      assert_match "Mines, from Simon Tatham's Portable Puzzle Collection", shell_output(bin/"mines")
    end
  end
end
