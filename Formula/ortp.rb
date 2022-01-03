class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://www.linphone.org/technical-corner/ortp"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.0.63/ortp-5.0.63.tar.bz2"
  sha256 "0182305e590ef62c3e29a64eea506c3e3282ffb6acff48d107689545a7ceb09d"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_monterey: "f5c1b4e88cb8fc3e4ada6140375b64695529ea1181790f8e5f2c1b45a96d1543"
    sha256 cellar: :any, arm64_big_sur:  "186781df3e68ac1bfd86da9e54c18daaaad7e1ac5ada91100673155b5b6dda88"
    sha256 cellar: :any, monterey:       "b666e750d256a7204352957e336ca15d48f813126728833d8af5df0783d0f720"
    sha256 cellar: :any, big_sur:        "56cb88fda091ff2320a58e391c462df9a945220e412327c2708fe893410e36ed"
    sha256 cellar: :any, catalina:       "d3ac6ad68680cbd7e0ce3bb5e34034597b2f2a183a4f67626ea19ec342c7b87c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.0.63/bctoolbox-5.0.63.tar.bz2"
    sha256 "ac08b7d5ca646e0cf35dd504c1ac1ef520ab497df1a8cd4b00dc429368698ec5"
  end

  def install
    resource("bctoolbox").stage do
      args = std_cmake_args.reject { |s| s["CMAKE_INSTALL_PREFIX"] } + %W[
        -DCMAKE_INSTALL_PREFIX=#{libexec}
        -DENABLE_TESTS_COMPONENT=OFF
      ]
      system "cmake", ".", *args
      system "make", "install"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"

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
  end
end
