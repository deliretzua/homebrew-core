class Xsel < Formula
  desc "Command-line program for getting and setting the contents of the X selection"
  homepage "https://www.vergenet.net/~conrad/software/xsel/"
  url "https://github.com/kfish/xsel/archive/refs/tags/1.2.1.tar.gz"
  sha256 "18487761f5ca626a036d65ef2db8ad9923bf61685e06e7533676c56d7d60eb14"
  license "MIT"
  head "https://github.com/kfish/xsel.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "30abd9f1f7e2ff38f890f01f3c7919a9fcad59ada8c530b933583421cfcf6232"
    sha256 cellar: :any,                 arm64_monterey: "de069e6eb3b7f2ab28641b1be7c7df88a0ea59587e01e59b79ddc680e0226194"
    sha256 cellar: :any,                 arm64_big_sur:  "b32e829803d81ea7d09bb0911b31a20ac6c75fdbc67fa3c4c9184458e3d3ecb3"
    sha256 cellar: :any,                 ventura:        "358506ddb783e7b8ede9380e03c66bfc70d6d2846e5f5a10411d9eac286c55cd"
    sha256 cellar: :any,                 monterey:       "834b49b7669f077df30e1e791037b5ebabc657aef2d9b1c6c4c8425b8c401754"
    sha256 cellar: :any,                 big_sur:        "f596d08cffadf2bff12804cc18fc61ddb4cdf47599f869d938c7ebd860e1950d"
    sha256 cellar: :any,                 catalina:       "18f72e215611df386415475668dd769e37c6b715715e477ba39866f17a95c1f2"
    sha256 cellar: :any,                 mojave:         "8fd34073cf958d18b31d51f0e3d05f7a93e0a71b00cc696bdf4d4018409b3c46"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81062fbb7f2a56e6510ab0103c795e5f0091dafa810100d03a83b3295b3f577f"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "libxt" => :build
  depends_on "pkg-config" => :build
  depends_on "libx11"

  def install
    system "./autogen.sh", *std_configure_args
    system "./configure", *std_configure_args
    system "make", "install"
  end

  test do
    assert_match "Usage: xsel [options]", shell_output("#{bin}/xsel --help")
    assert_match "xsel version #{version} ", shell_output("#{bin}/xsel --version")
    assert_match "xsel: Can't open display", shell_output("DISPLAY= #{bin}/xsel -o 2>&1", 1)
  end
end
