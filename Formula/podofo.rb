class Podofo < Formula
  desc "Library to work with the PDF file format"
  homepage "https://github.com/podofo/podofo"
  url "https://github.com/podofo/podofo/archive/refs/tags/0.10.1.tar.gz"
  sha256 "9b2bb5d54185a547e440413ca2e9ec3ea9c522fec81dfeb9a23dbc3d65fbaa55"
  license all_of: ["LGPL-2.0-only", "GPL-2.0-only"]
  head "https://github.com/podofo/podofo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "258755f90e2bf304ecebf1d75222565b7f459bf54fff21257fce8f0e3d878145"
    sha256 cellar: :any,                 arm64_monterey: "a3c4c1c2e3c56ef71d5fd0695c29af7285470d667e3e20c948724b134b0cfd28"
    sha256 cellar: :any,                 arm64_big_sur:  "3ba91bad5414b285d6757c2996f46b46098144f39cea5a9c4909bc70c38730c8"
    sha256 cellar: :any,                 ventura:        "9e505385c717a890b2e34d4ac461137d54e17edd0810ca15fc1a6767e6ed4659"
    sha256 cellar: :any,                 monterey:       "0968e3f5ade3d5238dab169a7f17b072d9a34138cedbc58329c2026ffd075ce9"
    sha256 cellar: :any,                 big_sur:        "c03fa0eecd1e6a19d5df5f6f93f3346b85366a7a69b719c09d96ba72c6c44e44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb7267c6e6b65e87c1de6dcd3abb986dae987dca57697117cd75f40a3c5e4597"
  end

  depends_on "cmake" => :build
  depends_on "fontconfig"
  depends_on "freetype"
  depends_on "jpeg-turbo"
  depends_on "libidn"
  depends_on "libpng"
  depends_on "libtiff"
  depends_on "openssl@3"

  uses_from_macos "libxml2"

  def install
    args = %W[
      -DCMAKE_INSTALL_NAME_DIR=#{opt_lib}
      -DCMAKE_BUILD_WITH_INSTALL_NAME_DIR=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_CppUnit=ON
      -DCMAKE_DISABLE_FIND_PACKAGE_LUA=ON
      -DPODOFO_BUILD_TOOLS=TRUE
      -DFREETYPE_INCLUDE_DIR_FT2BUILD=#{Formula["freetype"].opt_include}/freetype2
      -DFREETYPE_INCLUDE_DIR_FTHEADER=#{Formula["freetype"].opt_include}/freetype2/config/
    ]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    cp test_fixtures("test.pdf"), testpath
    assert_match "500 x 800 pts", shell_output("#{bin}/podofopdfinfo test.pdf")
  end
end
