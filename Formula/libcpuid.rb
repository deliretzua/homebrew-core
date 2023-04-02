class Libcpuid < Formula
  desc "Small C library for x86 CPU detection and feature extraction"
  homepage "https://github.com/anrieff/libcpuid"
  url "https://github.com/anrieff/libcpuid/archive/v0.6.3.tar.gz"
  sha256 "da570fdeb450634d84208f203487b2e00633eac505feda5845f6921e811644fc"
  license "BSD-2-Clause"
  head "https://github.com/anrieff/libcpuid.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 ventura:      "b197362eee621d3118a68c1a5bd461beba3517c47fe014e1a94667e184f69557"
    sha256 cellar: :any,                 monterey:     "a0f4c5f49d9d96a02878b347591a648970f5b62c7913a14db6053cbc2ced9cf1"
    sha256 cellar: :any,                 big_sur:      "8ca0c97e736fb44cbb04e78fc8b952ee3d6fcad4bd4439aaad58ec0c1c3506ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "563a8283a606ee0f6c7e8cc48a1da9c8c444393055a68ce596b2c2b1dc1cc0f7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on arch: :x86_64

  def install
    system "autoreconf", "-ivf"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system bin/"cpuid_tool"
    assert_predicate testpath/"raw.txt", :exist?
    assert_predicate testpath/"report.txt", :exist?
    assert_match "CPUID is present", File.read(testpath/"report.txt")
  end
end
