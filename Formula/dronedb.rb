class Dronedb < Formula
  desc "Free and open source software for aerial data storage"
  homepage "https://github.com/DroneDB/DroneDB"
  url "https://github.com/DroneDB/DroneDB.git",
       tag:      "v1.0.12",
       revision: "849e92fa94dc7cf65eb756ecf3824f0fe9dbb797"
  license "MPL-2.0"
  revision 5
  head "https://github.com/DroneDB/DroneDB.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "385b7e014cd01ebe975194e62fb6917e2ea2bf614dd9ee1ce1aedea622e3ea04"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac9330dba84fc9e964b452c0e5d6e727a4971388d9544025b375d8b0885aa9f7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6ec8db84047c7f5817ad708e5f3f503434465bc5636c10249c6d9ddf8eb1f592"
    sha256 cellar: :any_skip_relocation, ventura:        "e29ad9a4f3cdd424ac6e1ec360c2fe3a4e606181c3b99630521a01bf5ee7bbff"
    sha256 cellar: :any_skip_relocation, monterey:       "999b528b1001e8a400150710f0a7882cf0d63c7d81dcbb0151f89fcb13fd2548"
    sha256 cellar: :any_skip_relocation, big_sur:        "9028df07246bb802017bf86661a82f6cfc5f6454c981e12faf0918265010b7bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "64be7d6adfb69874626657d344136d7ce373485db45ec72d459abfe9d0aa925c"
  end

  depends_on "cmake" => :build
  depends_on "gdal"
  depends_on "libspatialite"
  depends_on "libzip"
  depends_on "pdal"

  # Build patch for xcode 14.3
  patch do
    url "https://github.com/DroneDB/DroneDB/commit/28aa869dee5920c2d948e1b623f2f9d518bdcb1e.patch?full_index=1"
    sha256 "50e581aad0fd3226fe5999cc91f9a61fdcbc42c5ba2394d9def89b70183f9c96"
  end

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{bin}/ddb", "--version"
    system "#{bin}/ddb", "info", "."
    system "#{bin}/ddb", "init"
    assert_predicate testpath/".ddb/dbase.sqlite", :exist?
  end
end
