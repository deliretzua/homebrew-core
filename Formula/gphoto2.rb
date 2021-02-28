class Gphoto2 < Formula
  desc "Command-line interface to libgphoto2"
  homepage "http://www.gphoto.org/"
  url "https://downloads.sourceforge.net/project/gphoto/gphoto/2.5.27/gphoto2-2.5.27.tar.bz2"
  sha256 "30054e93a1bb59f501aabd5018713177ea04ce0cb28935319bd6ca80061e8d38"
  license "GPL-2.0-or-later"

  livecheck do
    url :stable
    regex(%r{url=.*?/gphoto2[._-]v?(\d+(?:\.\d+)+)\.t}i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "d268212bc96bdcd3df5f6cc289d7f62d9ad20ac0db6b2e5ca338c54b8e4b198f"
    sha256 cellar: :any, big_sur:       "f78b5393c2d68ce33d628f59222612882fe93738ecbeffe76c2de4abccc3c296"
    sha256 cellar: :any, catalina:      "c4c42c50ee8bddf1a6b930f0eed9165a9e45ef1fb92476616833726b002ab077"
    sha256 cellar: :any, mojave:        "3b0f309d8d21165b945bb2c22a29f55396cf345a3f9255bc143ab4020fae5442"
    sha256 cellar: :any, high_sierra:   "a5c57a8b09c87b31c07cd3dea6ca6c859486c55268aa9745df740b1ac52368b2"
  end

  depends_on "pkg-config" => :build
  depends_on "jpeg"
  depends_on "libgphoto2"
  depends_on "popt"
  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gphoto2 -v")
  end
end
