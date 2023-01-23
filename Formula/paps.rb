class Paps < Formula
  desc "Pango to PostScript converter"
  homepage "https://github.com/dov/paps"
  url "https://github.com/dov/paps/archive/v0.7.9.tar.gz"
  sha256 "5f0198a011533d915fbf9f5e47438148d1f3a056bcd90bc21d6ae6476b6f3abc"
  license "LGPL-2.0-or-later"

  bottle do
    sha256 cellar: :any, arm64_ventura:  "5ae25ca5af148e92c8c1d8c9b1d7ada1c15e6f3c7778534afd3e4b6e490503a4"
    sha256 cellar: :any, arm64_monterey: "e89a0f42d9551bfda4c320e72fb1073b1b678a91b51200f0437a80c01cd95f50"
    sha256 cellar: :any, arm64_big_sur:  "c848669c3526b218529a7fa6f2477cf93df7a7066f83897e599157efe5600085"
    sha256 cellar: :any, ventura:        "3e8efca3bdf7dfbac2ffe47ee334b2eb6c1b98d59cdca99e4bb92fdfb721d13d"
    sha256 cellar: :any, monterey:       "f71a32472aba742785c9dbd21c0f7e95f230f931077b8b22b3e45577a7fb36a0"
    sha256 cellar: :any, big_sur:        "1d347779b763c8c13ea13ceb33bfb94f8a65202ce94b6c363127233d5c29fccb"
    sha256               x86_64_linux:   "b23e4f35dca9a61464c55404d7d59159c7b79516f3a60c0106c77d915ba6c9e2"
  end

  depends_on "meson" => :build
  depends_on "ninja" => :build
  depends_on "pkg-config" => :build
  depends_on "fmt"
  depends_on "pango"

  def install
    system "meson", "setup", "build", *std_meson_args
    system "meson", "compile", "-C", "build", "--verbose"
    system "meson", "install", "-C", "build"
    pkgshare.install "examples"
  end

  test do
    system bin/"paps", pkgshare/"examples/small-hello.utf8", "--encoding=UTF-8", "-o", "paps.ps"
    assert_predicate testpath/"paps.ps", :exist?
    assert_match "%!PS-Adobe-3.0", (testpath/"paps.ps").read
  end
end
