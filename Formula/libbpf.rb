class Libbpf < Formula
  desc "Berkeley Packet Filter library"
  homepage "https://github.com/libbpf/libbpf"
  url "https://github.com/libbpf/libbpf/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "32b0c41eabfbbe8e0c8aea784d7495387ff9171b5a338480a8fbaceb9da8d5e5"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, x86_64_linux: "044236e83211dc5074ca7b5fe7db0d1eee21140bf5197832aea3eeb7660928b3"
  end

  depends_on "pkg-config" => :build
  depends_on "elfutils"
  depends_on :linux

  uses_from_macos "zlib"

  def install
    system "make", "-C", "src"
    system "make", "-C", "src", "install", "PREFIX=#{prefix}", "LIBDIR=#{lib}"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include "bpf/libbpf.h"
      #include <stdio.h>

      int main() {
        printf("%s", libbpf_version_string());
        return(0);
      }
    EOS
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lbpf", "-o", "test"
    system "./test"
  end
end
