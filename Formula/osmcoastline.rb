class Osmcoastline < Formula
  desc "Extracts coastline data from OpenStreetMap planet file"
  homepage "https://osmcode.org/osmcoastline/"
  url "https://github.com/osmcode/osmcoastline/archive/v2.4.0.tar.gz"
  sha256 "2c1a28313ed19d6e2fb1cb01cde8f4f44ece378393993b0059f447c5fce11f50"
  license "GPL-3.0-or-later"
  revision 2

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1f5235873b915bdaad8f414f39ff9352c12f8b0c69632bf89aae880af43589b5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f0de16062ceb978f4499a6b1163ba3bc99d99757568aa216e3df7f3ffe3b73b0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56d298a761c8e8f66b8867249e4adb10e568080abf1fab0b9bdadd3d17af9c7a"
    sha256 cellar: :any_skip_relocation, ventura:        "fd3193426214796466b3c9e701c014fe4849d2059ed2090451b70021be4bc59b"
    sha256 cellar: :any_skip_relocation, monterey:       "66952ff987318af4f2c41ebc2cc2e461cd5e248182adc7a4568487f4f3f23d29"
    sha256 cellar: :any_skip_relocation, big_sur:        "ea490875b3ebf828d3ec214aad5e234847506d4643a8253443e56387a5a2b313"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "151e40991e564cba6634a5629cfeba677a1889cbe0072c320e738cd08aacd59c"
  end

  depends_on "cmake" => :build
  depends_on "libosmium" => :build
  depends_on "gdal"
  depends_on "geos"
  depends_on "libspatialite"
  depends_on "lz4"

  uses_from_macos "sqlite"
  uses_from_macos "zlib"

  fails_with gcc: "5"

  def install
    protozero = Formula["libosmium"].opt_libexec/"include"
    system "cmake", ".", "-DPROTOZERO_INCLUDE_DIR=#{protozero}", *std_cmake_args
    system "make", "install"
  end

  test do
    (testpath/"input.opl").write <<~EOS
      n100 v1 x1.01 y1.01
      n101 v1 x1.04 y1.01
      n102 v1 x1.04 y1.04
      n103 v1 x1.01 y1.04
      w200 v1 Tnatural=coastline Nn100,n101,n102,n103,n100
    EOS
    system "#{bin}/osmcoastline", "-v", "-o", "output.db", "input.opl"
  end
end
