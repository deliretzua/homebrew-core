class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.71/ortp-5.2.71.tar.bz2"
  sha256 "7414e3c933aa7d78881dd81f131e41595d9b60cc6f96544c8961058518a9709a"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "541f1aac57fcca0e1747a63885a3fe96bc8cbb38d4d8cefcbbbbbe5f1de732bb"
    sha256 cellar: :any,                 arm64_monterey: "496ebc786374080de3ac9f7827345deb8e56d1049a8147baf5afbd1ecd04d514"
    sha256 cellar: :any,                 arm64_big_sur:  "d5322a8b7605bc067ae01344de710cdb41cca5f604e1c3f6d38638b597661ba0"
    sha256 cellar: :any,                 ventura:        "1aeb0b60f4e6bd3db34dc1ac263bf67865f5117a02ce796606872d2cd9e4f059"
    sha256 cellar: :any,                 monterey:       "b37883b3c1319b0764d42eecfc3b3fc8b6fa2263148e02cc17fd8faf1f1dc4bb"
    sha256 cellar: :any,                 big_sur:        "a8da42ea5872bf2bd22c78848d64757a4407b10f1dfa97a5f81d741a3bd4f45a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "06e904ba8ef153392f5e16e61da3128a34adb1c4375a473351ee30d1af03e3aa"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.71/bctoolbox-5.2.71.tar.bz2"
    sha256 "48eace9a9c82002f0983b7030abccdd11b45370b06c0d1251a111c7fb7b869a1"
  end

  def install
    resource("bctoolbox").stage do
      args = ["-DENABLE_TESTS_COMPONENT=OFF"]
      args << "-DCMAKE_C_FLAGS=-Wno-error=unused-parameter" if OS.linux?
      system "cmake", "-S", ".", "-B", "build",
                      *args,
                      *std_cmake_args(install_prefix: libexec)
      system "cmake", "--build", "build"
      system "cmake", "--install", "build"
    end

    ENV.prepend_path "PKG_CONFIG_PATH", libexec/"lib/pkgconfig"
    ENV.append "LDFLAGS", "-Wl,-rpath,#{libexec}/lib" if OS.linux?
    cflags = ["-I#{libexec}/include"]
    cflags << "-Wno-error=maybe-uninitialized" if OS.linux?

    args = %W[
      -DCMAKE_PREFIX_PATH=#{libexec}
      -DCMAKE_C_FLAGS=#{cflags.join(" ")}
      -DCMAKE_CXX_FLAGS=-I#{libexec}/include
      -DENABLE_DOC=NO
      -DENABLE_UNIT_TESTS=NO
    ]

    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
