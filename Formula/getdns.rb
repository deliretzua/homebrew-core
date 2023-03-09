class Getdns < Formula
  desc "Modern asynchronous DNS API"
  homepage "https://getdnsapi.net"
  license "BSD-3-Clause"
  head "https://github.com/getdnsapi/getdns.git", branch: "develop"

  stable do
    url "https://getdnsapi.net/releases/getdns-1-7-3/getdns-1.7.3.tar.gz"
    sha256 "f1404ca250f02e37a118aa00cf0ec2cbe11896e060c6d369c6761baea7d55a2c"

    # build patch to find libuv, remove in next release
    patch do
      url "https://github.com/getdnsapi/getdns/commit/ee534d10bf1aff0ff62b7ea8c0e2f894e015e429.patch?full_index=1"
      sha256 "7e3afaaaf89fd914eb425de33c3e097ef3df4f467f26434706108ebcda3db10b"
    end
  end

  # We check the GitHub releases instead of https://getdnsapi.net/releases/,
  # since the aforementioned first-party URL has a tendency to lead to an
  # `execution expired` error.
  livecheck do
    url :head
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "4d4343827478b52bd29d0a50f47b33dd0a593f6e7f1db26e1876f322cc2cc390"
    sha256 cellar: :any,                 arm64_big_sur:  "a2f14b090e9f994e1a48960768a8aae3d67875c3c26c7dd2761d388f7198a685"
    sha256 cellar: :any,                 monterey:       "5a1f9b22cd35ccb2beb53ab3cf9b2f7ef76b90e9a32f4e01ed944afaec1effa5"
    sha256 cellar: :any,                 big_sur:        "cb3cc2fad2e4085344a33cf75ae1eea852c5973df22600a1857b70263547430b"
    sha256 cellar: :any,                 catalina:       "a36147e16474bf12da43a8f0547bb91c7434bc0b18fd1bf685ad59016677a115"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a6f03909403cdc420e55a6af1dbba7bac9c0f554d5e1318f80aa11181b5ac8b"
  end

  depends_on "cmake" => :build
  depends_on "libev"
  depends_on "libevent"
  depends_on "libidn2"
  depends_on "libuv"
  depends_on "openssl@1.1"
  depends_on "unbound"

  def install
    system "cmake", "-S", ".", "-B", "build",
                    "-DCMAKE_INSTALL_RPATH=#{rpath}",
                    "-DPATH_TRUST_ANCHOR_FILE=#{etc}/getdns-root.key",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <getdns/getdns.h>
      #include <stdio.h>

      int main(int argc, char *argv[]) {
        getdns_context *context;
        getdns_dict *api_info;
        char *pp;
        getdns_return_t r = getdns_context_create(&context, 0);
        if (r != GETDNS_RETURN_GOOD) {
            return -1;
        }
        api_info = getdns_context_get_api_information(context);
        if (!api_info) {
            return -1;
        }
        pp = getdns_pretty_print_dict(api_info);
        if (!pp) {
            return -1;
        }
        puts(pp);
        free(pp);
        getdns_dict_destroy(api_info);
        getdns_context_destroy(context);
        return 0;
      }
    EOS
    system ENV.cc, "-I#{include}", "-o", "test", "test.c", "-L#{lib}", "-lgetdns"
    system "./test"
  end
end
