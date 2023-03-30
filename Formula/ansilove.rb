class Ansilove < Formula
  desc "ANSI/ASCII art to PNG converter"
  homepage "https://www.ansilove.org"
  url "https://github.com/ansilove/ansilove/releases/download/4.1.7/ansilove-4.1.7.tar.gz"
  sha256 "6f8e2f6248775d6f8aca23b197b372ca7f8df8ade589ca4d5fc9a813a5d32655"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ac2f9a170946699ea94dfdefd3e2871f7d29ab8edb0164eea5e8662ce4f6c649"
    sha256 cellar: :any,                 arm64_monterey: "d132cbebe0b7721ff99b005736e156fda26d3c00f6b30237082e94b998235e90"
    sha256 cellar: :any,                 arm64_big_sur:  "50bf2d107f2f652d5001663abb0093c81b2097df35debfc9a6bffabb18b66058"
    sha256 cellar: :any,                 ventura:        "89a74f1d220239c3ca8d70635faf01cca65dccfa98c35fe0d835165d72f91ff7"
    sha256 cellar: :any,                 monterey:       "55dc300fa60aa6c07ceca616d721d37fd8bb80f1a0089a629193c78c5ee3cbb7"
    sha256 cellar: :any,                 big_sur:        "def7370b111a3bab2d6fcfc5642ddef272b3384d7a38d129b5a06252d271bcfa"
    sha256 cellar: :any,                 catalina:       "23311433311e4ac5df9d720d0f54903188b98cf08dc243be5e4c5984876d4e10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f6e591444c9d1288a71cc45904bb9bd1de75d878b44c3898cdeacdfae0834e7"
  end

  depends_on "cmake" => :build
  depends_on "libansilove"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args, "-DCMAKE_INSTALL_RPATH=#{rpath}"
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/burps/bs-ansilove.ans" => "test.ans"
  end

  test do
    output = shell_output("#{bin}/ansilove -o #{testpath}/output.png #{pkgshare}/test.ans")
    assert_match "Font: 80x25", output
    assert_match "Id: SAUCE v00", output
    assert_match "Tinfos: IBM VGA", output
    assert_predicate testpath/"output.png", :exist?
  end
end
