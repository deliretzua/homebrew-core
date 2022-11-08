class Yosys < Formula
  desc "Framework for Verilog RTL synthesis"
  homepage "https://yosyshq.net/yosys/"
  url "https://github.com/YosysHQ/yosys/archive/yosys-0.23.tar.gz"
  sha256 "ec982a9393b3217deecfbd3cf9a64109b85310a949e46a51cf2e07fba1071aeb"
  license "ISC"
  head "https://github.com/YosysHQ/yosys.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "072bd3a69018106165c75b3cf1c13236fc95fc5f2e649b3aa80feafab12e3804"
    sha256 arm64_monterey: "377dfda51d809d5588a476699113ad2ce0c0b9f3abd6be687109bccaeb7fad87"
    sha256 arm64_big_sur:  "f9feb6111f9e1d8c91a37317f35fba5ff55397af5f8a025072870ca13879a348"
    sha256 monterey:       "ab7f402e151e1612424a1fa96c425f454ddc95bfae81f8e2c64943dbfaf67d6b"
    sha256 big_sur:        "9d263cff821610171b3c33c065b190c91467dd50a362bbffac72885bc2296825"
    sha256 catalina:       "a15d5c2889f42b41aec24b97553118802c5d251309f0ea87c5f1251f65802c42"
    sha256 x86_64_linux:   "05032e62a7c0e69bba174275964fe0cd550d4bccabba2cfa3e9fcb877d9ce892"
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.10"
  depends_on "readline"

  uses_from_macos "flex"
  uses_from_macos "libffi", since: :catalina
  uses_from_macos "tcl-tk"

  def install
    system "make", "install", "PREFIX=#{prefix}", "PRETTY=0"
  end

  test do
    system bin/"yosys", "-p", "hierarchy; proc; opt; techmap; opt;", "-o", "synth.v", pkgshare/"adff2dff.v"
  end
end
