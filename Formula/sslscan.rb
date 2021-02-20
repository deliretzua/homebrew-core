class Sslscan < Formula
  desc "Test SSL/TLS enabled services to discover supported cipher suites"
  homepage "https://github.com/rbsec/sslscan"
  url "https://github.com/rbsec/sslscan/archive/2.0.8.tar.gz"
  sha256 "c21f12082bf554908d824fcd2ce342dff1a1dbcab98efa9ea033f5ebdec7974e"
  license "GPL-3.0-or-later"
  head "https://github.com/rbsec/sslscan.git"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)(?:-rbsec)?$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "f1170706f834f5b2e4a39f242cb6ab4128039ec5d7e6f0a9d232549558549795"
    sha256 cellar: :any, big_sur:       "d670583c1d9601c07683d3220a6823e47b981783b596cb09f05923cf10aa3ab6"
    sha256 cellar: :any, catalina:      "2a770856849153a648f7f94eb54a841982be5115575ceec4bcab56c245f4fc0a"
    sha256 cellar: :any, mojave:        "d13dfa1b044e9d3be2f1d4508f5db0d6e1fa4fa35e4afb01ee18a9267e11534a"
  end

  depends_on "openssl@1.1"

  def install
    # use `libcrypto.dylib` built from `openssl@1.1`
    inreplace "Makefile", "static: openssl/libcrypto.a",
                          "static: #{Formula["openssl@1.1"].opt_lib}/libcrypto.dylib"

    system "make", "static"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    assert_match "static", shell_output("#{bin}/sslscan --version")
    system "#{bin}/sslscan", "google.com"
  end
end
