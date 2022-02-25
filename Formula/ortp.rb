class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.1.3/ortp-5.1.3.tar.bz2"
  sha256 "80f1c5c33900c9dddb60248ce5b8f07af2d75275af340a42616a73dff2762fa4"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "ec18ab195f54430625e8cf55fd582e3acb6a6825d2c4cc78ea3034e036ef6497"
    sha256 cellar: :any, arm64_big_sur:  "2a6afdc6119937d71eb16c80044b937103eba9b237781a65f7bbb62091baca2f"
    sha256 cellar: :any, monterey:       "688d6256ac94230b4f61ed68c64f694a5e3db100e56ae25937d91f9097348147"
    sha256 cellar: :any, big_sur:        "1fc43da294754c1c93abe009d2e026dc8bd4f8c9c0cc17cd62d85286e07d162f"
    sha256 cellar: :any, catalina:       "7237630838ee86b55199a5d275f37e20101977788f89fe83d9a9028cc4b30d93"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.1.3/bctoolbox-5.1.3.tar.bz2"
    sha256 "272fe3b419c7ce8c9b042f2cdcd800a8b04940e5fedd1d488112c9bd471ee961"
  end

  def install
    resource("bctoolbox").stage do
      system "cmake", ".", *std_cmake_args(install_prefix: libexec), "-DENABLE_TESTS_COMPONENT=OFF"
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?

    args = std_cmake_args + %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=-I#{libexec}/include
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
      -DENABLE_DOC=NO
    ]
    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
    end
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "ortp/logging.h"
      #include "ortp/rtpsession.h"
      #include "ortp/sessionset.h"
      int main()
      {
        ORTP_PUBLIC void ortp_init(void);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-I#{libexec}/include", "-L#{lib}", "-lortp",
           testpath/"test.c", "-o", "test"
    system "./test"

    # Ensure that bctoolbox's version is identical to ortp's.
    assert_equal version, resource("bctoolbox").version
  end
end
