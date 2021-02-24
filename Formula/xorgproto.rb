class Xorgproto < Formula
  desc "X.Org: Protocol Headers"
  homepage "https://www.x.org/"
  url "https://xorg.freedesktop.org/archive/individual/proto/xorgproto-2021.2.tar.bz2"
  sha256 "ef95988b324573221b3599c8bb2bf07fe25fe55cf430c603ef0a15c0d4884ba2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a9fc28b855d68d640fdd985de0dd67f2a6aff09c12cef16e85adbd13aaef75da"
    sha256 cellar: :any_skip_relocation, big_sur:       "544326e121b491df07548620fd34df91c127b041e5f2f633f12e01738ea349a7"
    sha256 cellar: :any_skip_relocation, catalina:      "b50060e1137a990a6cb6c873c4f2bf8383af62285fdb229445d2d160f84d0736"
    sha256 cellar: :any_skip_relocation, mojave:        "0809cb3a8941d8e3994a9f940e181b465fb67db49e8dc2e434fbd53d10f04e3c"
    sha256 cellar: :any_skip_relocation, high_sierra:   "11537fb587e7d0e539a60850f62327ded423b635969e846865dbdded481d24c8"
  end

  depends_on "pkg-config" => [:build, :test]
  depends_on "util-macros" => :build

  def install
    args = %W[
      --prefix=#{prefix}
      --sysconfdir=#{etc}
      --localstatedir=#{var}
      --disable-dependency-tracking
      --disable-silent-rules
    ]

    system "./configure", *args
    system "make", "install"
  end

  test do
    assert_equal "-I#{include}", shell_output("pkg-config --cflags xproto").chomp
    assert_equal "-I#{include}/X11/dri", shell_output("pkg-config --cflags xf86driproto").chomp
  end
end
