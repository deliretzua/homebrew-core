class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "http://www.clifford.at/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.10.tar.gz"
  sha256 "eeec77e1983fd978fbff0257c4f4fb0d9bc07e403a13b9fc467878df3467b191"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_big_sur: "e2df722fe6fd54e15f7683bc49ec6f77895fd97687d38743507deb88c091c982"
    sha256 big_sur:       "6ecd94923b663972312bf1c6e50ddfef817ffb7257118e6d1f0bd6836d3057a5"
    sha256 catalina:      "30136c3fe55e45d36aa1587a48bc69030930563b2fb0f386ce122d79a4dbba87"
    sha256 mojave:        "6298e8bfeff2fa1f4de993642b43afeacb6c98a3f262c256d495339ee141dff4"
    sha256 high_sierra:   "a8807693a57f363e1a2d95034feffa3ab14c3645910f154d128990ae0484439e"
    sha256 x86_64_linux:  "2e439a8632b343ede0a5cbd4adb2b545f1bd0ca96090129304fb2958e5ebe384"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libffi"
  depends_on "python@3.9"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "tcl-tk"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system "#{bin}/yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", "#{pkgshare}/adff2dff.v"
  end
end
