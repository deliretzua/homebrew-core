class Bzip3 < Formula
  desc "Better and stronger spiritual successor to BZip2"
  homepage "https://github.com/kspalaiologos/bzip3"
  url "https://github.com/kspalaiologos/bzip3/releases/download/1.2.1/bzip3-1.2.1.tar.gz"
  sha256 "bba90d867f53efa4291de1df9c22da1578e1a93ca819e0fc68881da6fcc4149d"
  license "LGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "58e82bc277f6b019bc17c2b30acd4ead18a4d60f52d1271a0ea03b3e51757333"
    sha256 cellar: :any,                 arm64_monterey: "bc9b8e4027bdd0a27dd0fd900d8a0b7900df5dbf4c39c183ad2c3549039ec703"
    sha256 cellar: :any,                 arm64_big_sur:  "4708822e7f06fe65a62a9b35606b0dd8243373845194d3b9c6d8e2b7d9563e8c"
    sha256 cellar: :any,                 ventura:        "3586f26debbee5c8ad9e1a2a72368d91cbe08bcadebfde95695c4bd3fecabc30"
    sha256 cellar: :any,                 monterey:       "d6610408df172f22e746dab08602c07772c3bf76db11c1d98d85307a0565f0e5"
    sha256 cellar: :any,                 big_sur:        "9acf778c85c51dc05573eb120546e1e6dafd07d68a7b747a86096f18b964f889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "652ff77bbe2107000ebfea60b7f37cdcf621e6693f4705b5d457d072ca500408"
  end

  # Fix -flat_namespace being used on Big Sur and later.
  # upstream patch commit, https://github.com/kspalaiologos/bzip3/commit/e667cacfaa0b4b56e45d48e0496041c376c82d53
  # remove in next release
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
    sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
  end

  def install
    system "./configure", *std_configure_args, "--disable-silent-rules", "--disable-arch-native"
    system "make", "install"
  end

  test do
    testfilepath = testpath + "sample_in.txt"
    zipfilepath = testpath + "sample_in.txt.bz3"

    testfilepath.write "TEST CONTENT"

    system bin/"bzip3", testfilepath
    system bin/"bunzip3", "-f", zipfilepath

    assert_equal "TEST CONTENT", testfilepath.read
  end
end
