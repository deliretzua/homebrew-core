class Zeek < Formula
  desc "Network security monitor"
  homepage "https://www.zeek.org"
  url "https://github.com/zeek/zeek.git",
      tag:      "v4.0.0",
      revision: "7b5263139e9909757c38dfca4c99abebf958df67"
  license "BSD-3-Clause"
  revision 3
  head "https://github.com/zeek/zeek.git"

  bottle do
    sha256 arm64_big_sur: "2da21fcb3ca181e6d9a5eab0da9f11167670c1a48519b357a83de4d3581cedad"
    sha256 big_sur:       "64523156d14d219b5bbcaadf53a25049543e37cf19da44d757c90f7dc8c8955b"
    sha256 catalina:      "01db400b0f88149a80e16399ccbc8bf663a63044e2aa3218b8e602e848f64c3c"
    sha256 mojave:        "3cea14ff2d54a633f84a33eabfd71e10a720992a49242a22ccb22130650b6733"
  end

  depends_on "bison" => :build
  depends_on "cmake" => :build
  depends_on "swig" => :build
  depends_on "caf"
  depends_on "geoip"
  depends_on "libmaxminddb"
  depends_on macos: :mojave
  depends_on "openssl@1.1"
  depends_on "python@3.9"

  uses_from_macos "flex"
  uses_from_macos "libpcap"

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args,
                      "-DBROKER_DISABLE_TESTS=on",
                      "-DBUILD_SHARED_LIBS=on",
                      "-DINSTALL_AUX_TOOLS=on",
                      "-DINSTALL_ZEEKCTL=on",
                      "-DUSE_GEOIP=on",
                      "-DCAF_ROOT=#{Formula["caf"].opt_prefix}",
                      "-DOPENSSL_ROOT_DIR=#{Formula["openssl@1.1"].opt_prefix}",
                      "-DZEEK_ETC_INSTALL_DIR=#{etc}",
                      "-DZEEK_LOCAL_STATE_DIR=#{var}"
      system "make", "install"
    end
  end

  test do
    assert_match "version #{version}", shell_output("#{bin}/zeek --version")
    assert_match "ARP packet analyzer", shell_output("#{bin}/zeek --print-plugins")
  end
end
