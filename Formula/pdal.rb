class Pdal < Formula
  desc "Point data abstraction library"
  homepage "https://www.pdal.io/"
  url "https://github.com/PDAL/PDAL/releases/download/2.5.5/PDAL-2.5.5-src.tar.bz2"
  sha256 "b32b16475619a6bdfaee5a07a9b859206e18de5acff2a4447502fd0a9c6538d6"
  license "BSD-3-Clause"
  revision 2
  head "https://github.com/PDAL/PDAL.git", branch: "master"

  # The upstream GitHub repository sometimes creates tags that only include a
  # major/minor version (`1.2`) and then uses major/minor/patch (`1.2.0`) for
  # the release tarball. This inconsistency can be a problem if we need to
  # substitute the version from livecheck in the `stable` URL, so we check the
  # first-party download page, which links to the tarballs on GitHub.
  livecheck do
    url "https://pdal.io/en/latest/download.html"
    regex(/href=.*?PDAL[._-]v?(\d+(?:\.\d+)+)[._-]src\.t/i)
  end

  bottle do
    sha256                               arm64_ventura:  "a38e553f68a09c3587cd65d0f02c3c7709e415aec1bec4e78fd99a389789c1a7"
    sha256                               arm64_monterey: "0149f3db3bd636b5342d06f981a2a9a5a07d2a853b90a92732604831bcd7d5dd"
    sha256                               arm64_big_sur:  "17b6f85b6036aebbbb8711a0307c260ed5fb7b362c885f3c4a62890319b99889"
    sha256                               ventura:        "43e81b670d52c38b9c5599e566cef33ab83c69378e06b7a4ebddb9695856bff6"
    sha256                               monterey:       "84b88376ea8f2def752a22e75ece59b025597568a7207aa52c8a301d5d5eb987"
    sha256                               big_sur:        "9f48baecd985b586d7b607cd20f40ba0c2340407ef8e9d6ffa04401a59906308"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56f8c8662b2c149e25f4614b550fffad4a9e00f1cc577fb63ecfb2abe5e6e0eb"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "gdal"
  depends_on "hdf5"
  depends_on "laszip"
  depends_on "libpq"
  depends_on "numpy"
  depends_on "openssl@3"

  fails_with gcc: "5" # gdal is compiled with GCC

  def install
    system "cmake", ".", *std_cmake_args,
                         "-DWITH_LASZIP=TRUE",
                         "-DBUILD_PLUGIN_GREYHOUND=ON",
                         "-DBUILD_PLUGIN_ICEBRIDGE=ON",
                         "-DBUILD_PLUGIN_PGPOINTCLOUD=ON",
                         "-DBUILD_PLUGIN_PYTHON=ON",
                         "-DBUILD_PLUGIN_SQLITE=ON"

    system "make", "install"
    rm_rf "test/unit"
    doc.install "examples", "test"
  end

  test do
    system bin/"pdal", "info", doc/"test/data/las/interesting.las"
  end
end
