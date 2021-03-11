class Kakoune < Formula
  desc "Selection-based modal text editor"
  homepage "https://github.com/mawww/kakoune"
  url "https://github.com/mawww/kakoune/releases/download/v2020.09.01/kakoune-2020.09.01.tar.bz2"
  sha256 "861a89c56b5d0ae39628cb706c37a8b55bc289bfbe3c72466ad0e2757ccf0175"
  license "Unlicense"
  head "https://github.com/mawww/kakoune.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f13df3ca9284dce44ff46cf2d4f29bc65baa8eda0421dd280798a0190329ce6e"
    sha256 cellar: :any, big_sur:       "9578dcfc73d6c978fda9ed31194ab0a1599fbab35faf506ccf92ee8f0466e387"
    sha256 cellar: :any, catalina:      "19ff009f6f44de0e54fc01736f8e145bc6a866307f18adf5a002c8053b7e2bd9"
    sha256 cellar: :any, mojave:        "48b2c91f86c65517c8a83a0a0083bc7c0bf54a4e8fc93b22b5744f7c0ce4fc33"
    sha256 cellar: :any, high_sierra:   "dbee14709bcbe746293b0a80852347cc53cb646c9013b6fc119ee37aab4ab859"
  end

  depends_on macos: :high_sierra # needs C++17
  depends_on "ncurses"

  on_linux do
    depends_on "binutils" => :build
    depends_on "linux-headers" => :build
    depends_on "pkg-config" => :build
    depends_on "gcc"
  end

  fails_with gcc: "5"
  fails_with gcc: "6"

  def install
    cd "src" do
      system "make", "install", "debug=no", "PREFIX=#{prefix}"
    end
  end

  test do
    system bin/"kak", "-ui", "dummy", "-e", "q"
  end
end
