class Mavsdk < Formula
  desc "API and library for MAVLink compatible systems written in C++17"
  homepage "https://mavsdk.mavlink.io"
  url "https://github.com/mavlink/MAVSDK.git",
      tag:      "v0.38.0",
      revision: "9126237b1f354e1b45426541d881407c2707328f"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_big_sur: "d7eebb0410419df45f444d1f82b1e865134d130d1edc65303ab49c5d89898a38"
    sha256 big_sur:       "b562750790c3fdeebe9efc8f1e58bb59246815b7de7390bcb9d3f1ca03c3b10d"
    sha256 catalina:      "398ec74acdd09c6afe120912a9971af0f7d708431a192ad430330fce756c9c32"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "c-ares"
  depends_on "curl"
  depends_on "grpc"
  depends_on "jsoncpp"
  depends_on macos: :catalina # Mojave libc++ is too old
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "re2"
  depends_on "tinyxml2"

  uses_from_macos "zlib"

  # Fix build error on Catalina
  # error: use of undeclared identifier 'MSG_NOSIGNAL'
  # Remove when the following PR has landed in a release:
  # https://github.com/mavlink/MAVSDK/pull/1382
  patch do
    url "https://github.com/mavlink/MAVSDK/commit/43f8713d3793955d6fe4793592e81b5a1f998439.patch?full_index=1"
    sha256 "6219405c44c7c78ab843734afa1ab708d96a376c49708f3cbf686f7edb5f46c3"
  end

  def install
    # Source build adapted from
    # https://mavsdk.mavlink.io/develop/en/contributing/build.html
    system "cmake", *std_cmake_args,
                    "-Bbuild/default",
                    "-DSUPERBUILD=OFF",
                    "-DBUILD_SHARED_LIBS=ON",
                    "-DBUILD_MAVSDK_SERVER=ON",
                    "-DBUILD_TESTS=OFF",
                    "-DCMAKE_INSTALL_RPATH=#{lib}",
                    "-H."
    system "cmake", "--build", "build/default"
    system "cmake", "--build", "build/default", "--target", "install"
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #include <mavsdk/mavsdk.h>
      #include <mavsdk/plugins/info/info.h>
      int main() {
          mavsdk::Mavsdk mavsdk;
          mavsdk.version();
          mavsdk::System& system = mavsdk.system();
          auto info = std::make_shared<mavsdk::Info>(system);
          return 0;
      }
    EOS
    system ENV.cxx, "-std=c++17", testpath/"test.cpp", "-o", "test",
                  "-I#{include}/mavsdk",
                  "-L#{lib}",
                  "-lmavsdk",
                  "-lmavsdk_info"
    system "./test"

    assert_equal "Usage: #{bin}/mavsdk_server [-h | --help]",
                 shell_output("#{bin}/mavsdk_server --help").split("\n").first
  end
end
