class Ortp < Formula
  desc "Real-time transport protocol (RTP, RFC3550) library"
  homepage "https://linphone.org/"
  url "https://gitlab.linphone.org/BC/public/ortp/-/archive/5.2.12/ortp-5.2.12.tar.bz2"
  sha256 "7b366b201cd3ae2a7545c8cda156269d255439aa86777cc8ab4ef67e6cf343ea"
  license "GPL-3.0-or-later"
  head "https://gitlab.linphone.org/BC/public/ortp.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7e079a2da11098067127d7924a116ea37f76b9c93c441c21515ed2106f6000fc"
    sha256 cellar: :any,                 arm64_monterey: "90e741e64f36fb85e80ba6fe6d79f0f656e0d5d3e8bb81bbc85035f9ee0eea29"
    sha256 cellar: :any,                 arm64_big_sur:  "67995c8230fc6f5d8d0083db04c9f54cd95bf3f433fb09de5486539d5cc88898"
    sha256 cellar: :any,                 ventura:        "643f087af84e7837ade522b525df7b2d5e4a32377710f2576f1b2e1addf7af1d"
    sha256 cellar: :any,                 monterey:       "04904f015fbbb1a2189ef080ed3587cbb505a1e107dd0f34272f6390b0daf0a0"
    sha256 cellar: :any,                 big_sur:        "bdc753375a76be20ed30ae82b0a161ba002a989975e3e8f0f28025faa6a7b2df"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6314b1b2cbda752eaa1dd6b3ee4c7f496599a8046045e21a612dd1312356f541"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "mbedtls@2"

  # bctoolbox appears to follow ortp's version. This can be verified at the GitHub mirror:
  # https://github.com/BelledonneCommunications/bctoolbox
  resource "bctoolbox" do
    # Don't forget to change both instances of the version in the URL.
    url "https://gitlab.linphone.org/BC/public/bctoolbox/-/archive/5.2.12/bctoolbox-5.2.12.tar.bz2"
    sha256 "e8cac360d54d84bf4c010b9ac24f39970e4d3c7fbd2ad6410b664c5840d8d552"
  end

  def install
    resource("bctoolbox").stage do
      system "cmake", "-S", ".", "-B", "build",
                      "-DENABLE_TESTS_COMPONENT=OFF",
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
