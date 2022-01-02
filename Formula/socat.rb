class Socat < Formula
  desc "SOcket CAT: netcat on steroids"
  homepage "http://www.dest-unreach.org/socat/"
  url "http://www.dest-unreach.org/socat/download/socat-1.7.4.2.tar.gz"
  sha256 "a38f507dea8aaa8f260f54ebc1de1a71e5adca416219f603cda3e3002960173c"
  license "GPL-2.0"

  livecheck do
    url "http://www.dest-unreach.org/socat/download/"
    regex(/href=.*?socat[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "bebff01d4a9da5539be0c56064458506ef3c2e098e66e3ecdd81a56b953b18bc"
    sha256 cellar: :any,                 arm64_big_sur:  "ab41a0fff966fe7d766604de9392c18fb5fb1bbe938fcb13ed2861ba9d7e65bb"
    sha256 cellar: :any,                 monterey:       "7de63a881d222435b6ea2f416a93f758f265feb87573b2bd8045b6fc383196ee"
    sha256 cellar: :any,                 big_sur:        "4ee020dff0b50603598022a6d924fffdf105fd175772fbbd84efdd52397ac023"
    sha256 cellar: :any,                 catalina:       "e45f83eee32c323aca752b3a63075b8d65b4eff1814bcce3cd5fdd01c7a526f7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1f1932cc4004c5f6234de385b59e36ce686d6e7e152526d9b47dd9fd9bfd13c4"
  end

  depends_on "openssl@1.1"
  depends_on "readline"

  # Fix `error: use of undeclared identifier 'TCP_INFO'`
  # Remove in the next release
  patch :DATA

  def install
    system "./configure", *std_configure_args, "--mandir=#{man}"
    system "make", "install"
  end

  test do
    output = pipe_output("#{bin}/socat - tcp:www.google.com:80", "GET / HTTP/1.0\r\n\r\n")
    assert_match "HTTP/1.0", output.lines.first
  end
end

__END__
diff --git a/filan.c b/filan.c
index 3465f7c..77c22a4 100644
--- a/filan.c
+++ b/filan.c
@@ -905,6 +905,7 @@ int tcpan(int fd, FILE *outfile) {
 #if WITH_TCP

 int tcpan2(int fd, FILE *outfile) {
+#ifdef TCP_INFO
    struct tcp_info tcpinfo;
    socklen_t tcpinfolen = sizeof(tcpinfo);
    int result;
@@ -930,6 +931,8 @@ int tcpan2(int fd, FILE *outfile) {
    // fprintf(outfile, "%s={%u}\t", "TCPI_", tcpinfo.tcpi_);

    return 0;
+#endif
+   return -1;
 }

 #endif /* WITH_TCP */
