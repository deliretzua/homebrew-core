class Mongoose < Formula
  desc "Web server build on top of Libmongoose embedded library"
  homepage "https://github.com/cesanta/mongoose"
  url "https://github.com/cesanta/mongoose/archive/7.4.tar.gz"
  sha256 "6ecf0534a9a7834455abc410226066ac038d0e43c25eb7cc3a4585f9d767e477"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "be10036a119761682e5c9f32c3bd978acf276ecd06563b82d4cde8a8c011fee2"
    sha256 cellar: :any,                 big_sur:       "c5ef89da82e99a598d31ce123065318add458d5ba1b007b2a23e867efaf4a5c9"
    sha256 cellar: :any,                 catalina:      "e59f2e2c32835593d7e919c9334280bbb345d5480014f312cfbe014622cfc777"
    sha256 cellar: :any,                 mojave:        "9a73787553ae39eb1510b9ba46cb95718403682a859eabc636ca046532df22be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "17f1e400a66f7be82e5ad2c774674efb308733e5302b91c75aa0924644fb01e2"
  end

  depends_on "openssl@1.1"

  conflicts_with "suite-sparse", because: "suite-sparse vendors libmongoose.dylib"

  def install
    # No Makefile but is an expectation upstream of binary creation
    # https://github.com/cesanta/mongoose/issues/326
    cd "examples/http-server" do
      system "make", "mongoose_mac", "PROG=mongoose_mac"
      bin.install "mongoose_mac" => "mongoose"
    end

    system ENV.cc, "-dynamiclib", "mongoose.c", "-o", "libmongoose.dylib" if OS.mac?
    if OS.linux?
      system ENV.cc, "-fPIC", "-c", "mongoose.c"
      system ENV.cc, "-shared", "-Wl,-soname,libmongoose.so", "-o", "libmongoose.so", "mongoose.o", "-lc", "-lpthread"
    end
    lib.install shared_library("libmongoose")
    include.install "mongoose.h"
    pkgshare.install "examples"
    doc.install Dir["docs/*"]
  end

  test do
    (testpath/"hello.html").write <<~EOS
      <!DOCTYPE html>
      <html>
        <head>
          <title>Homebrew</title>
        </head>
        <body>
          <p>Hi!</p>
        </body>
      </html>
    EOS

    begin
      pid = fork { exec "#{bin}/mongoose" }
      sleep 2
      assert_match "Hi!", shell_output("curl http://localhost:8000/hello.html")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
