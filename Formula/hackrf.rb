class Hackrf < Formula
  desc "Low cost software radio platform"
  homepage "https://github.com/mossmann/hackrf"
  url "https://github.com/mossmann/hackrf/archive/v2021.03.1.tar.gz"
  sha256 "84a9aef6fe2666744dc1a17ba5adb1d039f8038ffab30e9018dcfae312eab5be"
  license "GPL-2.0-or-later"
  head "https://github.com/mossmann/hackrf.git"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any, arm64_big_sur: "04c7f5c356012bcc072a080439f7edb20742ad3a8917a5a7f07ba83e0d4605a9"
    sha256 cellar: :any, big_sur:       "fafc41d9d60bcfee157d7b30efc8ea97b507ad20135f60479ae9840235bae2ad"
    sha256 cellar: :any, catalina:      "4004e867109e43fb7f9613c01a99ffd3d8dee0949d6f27232b06bf740d1e1776"
    sha256 cellar: :any, mojave:        "9c0610e7d8fe8f1e840b38d3ce6eeab741842a95f227025fbca24c417ae30549"
    sha256 cellar: :any, high_sierra:   "430173362cc05912520a38f41ce465a0966f1c8d849fd492f0b40074425c3f88"
    sha256 cellar: :any, sierra:        "f33bc6bde41e6522d587bc574c01e1402ccbde6759dec5e9d1a1e5f593e189b3"
    sha256 cellar: :any, el_capitan:    "909a5a9aca6f81cbab08bb7c063f3ee0e666bb5b44af86ebbec62cbdaf3e3b33"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "fftw"
  depends_on "libusb"

  def install
    cd "host" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    shell_output("#{bin}/hackrf_transfer", 1)
  end
end
