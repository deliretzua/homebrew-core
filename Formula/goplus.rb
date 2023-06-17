class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/v1.1.5.tar.gz"
  sha256 "ce93d5ff9a939a3fb3fd8d0f8c2db6ed38b799c302028ce222bfa41c01992210"
  license "Apache-2.0"
  revision 1
  head "https://github.com/goplus/gop.git", branch: "main"

  bottle do
    sha256 arm64_ventura:  "5072eb227bae0937507c8f8aa0244c7635f926360b3a274236cd92908e4cdf42"
    sha256 arm64_monterey: "7587295dcb376e1a94858a8833b2807f0fa5b810f8fcac1d44fcaa386d62d5fe"
    sha256 arm64_big_sur:  "70bc34841b2f369c045901c636d05fe44b6e99f0739b34ff3fd2156299f910aa"
    sha256 ventura:        "61c3b6f81329e716160d9366aa8d7a6778e644a751fe00a0fb0c60402287c76d"
    sha256 monterey:       "d29ac15d66b04f7ec9cef3f0db40b5b13ab62c214dd118d9c4dc9141a312920f"
    sha256 big_sur:        "a11e3c53e8f71454fe4aaf9522d9c7fc3769851c66c5c74192609875e75dcbf1"
    sha256 x86_64_linux:   "ddee63d2da99c663f77c56a9d7e0162a2a1b3594ef6d452a0d9b19f677e1fb5e"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"hello.gop").write <<~EOS
      println("Hello World")
    EOS

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp unless head?
    system bin/"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}/gop run hello.gop")

    (testpath/"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello")
  end
end
