class Zmap < Formula
  desc "Network scanner for Internet-wide network studies"
  homepage "https://zmap.io"
  url "https://github.com/zmap/zmap/archive/v3.0.0.tar.gz"
  sha256 "e3151cdcdf695ab7581e01a7c6ee78678717d6a62ef09849b34db39682535454"
  license "Apache-2.0"
  head "https://github.com/zmap/zmap.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "379a8920b68618ff9daeaedb12c0653e55d4f231d9d00c77e37251cb4d9a2706"
    sha256 arm64_monterey: "4f6a24cc441b2c1591370d13cd9f9b58b391780e4aee353976dd9698b1a85c2c"
    sha256 arm64_big_sur:  "c1ee5777fb69a3df8b0b0107404effdbaa3a6d73138fda9a93f279efd9c0bb8d"
    sha256 ventura:        "4864581bb657fecbcaf07f318d343455706766543a45e605f63fd23b2a9746d1"
    sha256 monterey:       "f68c0305b46be402d4b41bb709960228e76f4c17b7b39f42cdd5b11460dea905"
    sha256 big_sur:        "edcf5c3a608c25386b8b5719ffba9ee6f18a140593c4dc941b43a768d1d14084"
    sha256 catalina:       "7e94d9738a92dff6de1e76d69ab0e38ca7c6488d06c34d5bb40c3aa8cb08c8f4"
    sha256 x86_64_linux:   "bf4676cca925307267ddc7fae14da7c3d4857a4636088a2c3361ec193ebc2137"
  end

  depends_on "byacc" => :build
  depends_on "cmake" => :build
  depends_on "gengetopt" => :build
  depends_on "pkg-config" => :build
  depends_on "gmp"
  depends_on "json-c"
  depends_on "libdnet"
  depends_on "libunistring" # for unistr.h

  uses_from_macos "flex" => :build
  uses_from_macos "libpcap"

  def install
    inreplace ["conf/zmap.conf", "src/constants.h", "src/zopt.ggo.in"], "/etc", etc
    args = %w[-DENABLE_DEVELOPMENT=OFF -DRESPECT_INSTALL_PREFIX_CONFIG=ON]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system "#{sbin}/zmap", "--version"
  end
end
