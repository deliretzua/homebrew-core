class Hstr < Formula
  desc "Bash and zsh history suggest box"
  homepage "https://github.com/dvorka/hstr"
  url "https://github.com/dvorka/hstr/archive/3.0.tar.gz"
  sha256 "6d523914dc3af243f5895b2e52d39e3cc53f1afed6562f34a29da4d4467ad7fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "05ac26217fb993171c064ff21277aef85d408b65cc229d9980c6e45bf845a758"
    sha256 cellar: :any,                 arm64_monterey: "6792271b3544187c87c845c017996c98d10aab9e1ee5795c304365b189843e45"
    sha256 cellar: :any,                 arm64_big_sur:  "d51d9fd2b944b73985b4582938a32f27f2ce1452113eee561f21b7722cfdda2a"
    sha256 cellar: :any,                 ventura:        "87dc6b7a714db1cbd5abb2d32536780a202c8dc13482b34d12ae10cb497db9cd"
    sha256 cellar: :any,                 monterey:       "875f71c5af7b2ca494653a8d8158696881dec6a75bf6922ea4804d87e0905fb5"
    sha256 cellar: :any,                 big_sur:        "434aa15b4470803881af8ea62389a6c58cd4cea8370a2a8e9deb30412874af8c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0596a252305581324bf2e41b9db298487385d6a7f8b584692fdec8370d426bc"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "readline"

  def install
    system "autoreconf", "-fvi"
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    ENV["HISTFILE"] = testpath/".hh_test"
    (testpath/".hh_test").write("test\n")
    assert_match "test", shell_output("#{bin}/hh -n").chomp
  end
end
