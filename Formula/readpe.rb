class Readpe < Formula
  desc "PE analysis toolkit"
  homepage "https://github.com/mentebinaria/readpe"
  url "https://github.com/mentebinaria/readpe/archive/refs/tags/v0.82.tar.gz"
  sha256 "6ee625acedb3cbe636afe41f854b6eed5aac466d7fad52e3a48557083f8acecc"
  license "GPL-2.0-or-later"
  head "https://github.com/mentebinaria/readpe.git", branch: "master"

  depends_on "openssl@3"

  resource "homebrew-testfile" do
    url "https://the.earth.li/~sgtatham/putty/0.78/w64/putty.exe"
    sha256 "fc6f9dbdf4b9f8dd1f5f3a74cb6e55119d3fe2c9db52436e10ba07842e6c3d7c"
  end

  def install
    ENV.deparallelize
    inreplace "lib/libpe/Makefile", "-flat_namespace", ""
    system "make", "prefix=#{prefix}", "CC=#{ENV.cc}"
    system "make", "prefix=#{prefix}", "install"
  end

  test do
    resource("homebrew-testfile").stage do
      assert_match(/Bytes in last page:\s+120/, shell_output("#{bin}/readpe ./putty.exe"))
    end
  end
end
