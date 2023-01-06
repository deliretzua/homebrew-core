class Recode < Formula
  desc "Convert character set (charsets)"
  homepage "https://github.com/rrthomas/recode"
  url "https://github.com/rrthomas/recode/releases/download/v3.7.13/recode-3.7.13.tar.gz"
  sha256 "22bbdf79725a59f4d84c3dad63a911c5e8f443f109443c032cad564900b6b733"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "36b3e395da0fa0dc36f82798e1cb1f993115dc05bd3fc23cfec2fce6d4a50f55"
    sha256 cellar: :any,                 arm64_monterey: "9de3695ef53d184456f3447e703d358bade6bcdf506a21dfee8d2d30ff381672"
    sha256 cellar: :any,                 arm64_big_sur:  "2ce7b2c21ae41e9d86dd967aeeca28d61827db5a2aa5de0fbbcf613461228249"
    sha256 cellar: :any,                 ventura:        "a313db5487582d69f4086a633a3f0c1223e2ed5250ef15a7f2d490c4fd25cfef"
    sha256 cellar: :any,                 monterey:       "c112fcae93ad14b4728c31cd2e5b6e0ffd3a2305caac0f8d5859d0571cc97f35"
    sha256 cellar: :any,                 big_sur:        "284ca96c22d0bff8ba5164f42df49524db62bdba3eff8cc87d5d759ecfb11946"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a0c4df1ad61f8427d75b9454142d15a88d2af7b642d03784c55e6b89fce29c0"
  end

  depends_on "help2man" => :build
  depends_on "libtool" => :build
  depends_on "python@3.11" => :build
  depends_on "gettext"

  # Fix -flat_namespace being used on Big Sur and later.
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/recode --version")
  end
end
