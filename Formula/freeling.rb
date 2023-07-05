class Freeling < Formula
  desc "Suite of language analyzers"
  homepage "https://nlp.lsi.upc.edu/freeling/"
  url "https://github.com/TALP-UPC/FreeLing/releases/download/4.2/FreeLing-src-4.2.1.tar.gz"
  sha256 "c672a6379142ac2e872741e7662f17eccd8230bffc680564d2843d87480f1600"
  license "AGPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "d1375d1d4cc6303dc9b156988355553dc8d6ec59348e337a52f55843ec300482"
    sha256 cellar: :any,                 arm64_monterey: "b4e0db7bbfb6ba92f46db0d2158b214b2c5be227d1b397996ffaf2575e42f723"
    sha256 cellar: :any,                 arm64_big_sur:  "d06b85bef4251aa6563e5ab30dbf11ae5e9474811cac288006f9ea30c18e419e"
    sha256 cellar: :any,                 ventura:        "b8f1a95c50bd350a81f094fde02de5efc6d2689b8308c0d9db975c8ceb321228"
    sha256 cellar: :any,                 monterey:       "3c9f5f25a3593caa160ee0c2e2843ddd400a2c6769df5c94654a7ae98c0ce6db"
    sha256 cellar: :any,                 big_sur:        "35f850be27e9b49d8f404c630632e782229db76072b08a3fd41e5fb85089a0d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f106e8ed2dfc18b30bc46e9bf416f5b3cc15c4e16045bf47aaeaabf36c7a7fd1"
  end

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "icu4c"

  conflicts_with "dynet", because: "freeling ships its own copy of dynet"
  conflicts_with "eigen", because: "freeling ships its own copy of eigen"
  conflicts_with "foma", because: "freeling ships its own copy of foma"
  conflicts_with "hunspell", because: "both install 'analyze' binary"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    libexec.install "#{bin}/fl_initialize"
    inreplace "#{bin}/analyze",
      ". $(cd $(dirname $0) && echo $PWD)/fl_initialize",
      ". #{libexec}/fl_initialize"
  end

  test do
    expected = <<~EOS
      Hello hello NN 1
      world world NN 1
    EOS
    assert_equal expected, pipe_output("#{bin}/analyze -f #{pkgshare}/config/en.cfg", "Hello world").chomp
  end
end
