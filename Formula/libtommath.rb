class Libtommath < Formula
  desc "C library for number theoretic multiple-precision integers"
  homepage "https://www.libtom.net/LibTomMath/"
  url "https://github.com/libtom/libtommath/releases/download/v1.2.0/ltm-1.2.0.tar.xz"
  sha256 "b7c75eecf680219484055fcedd686064409254ae44bc31a96c5032843c0e18b1"
  license "Unlicense"
  revision 2
  head "https://github.com/libtom/libtommath.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "efe92758582143141223011809f6f9d243e970a788669a3ba6eb0de6db9772a7"
    sha256 cellar: :any_skip_relocation, big_sur:       "fde5371efe622e6a4f425e8294e742879b57aa355e2b1a593ff18cac2cb29840"
    sha256 cellar: :any_skip_relocation, catalina:      "700d1c4dfecd1016215158de7436d02452a149c5882ba3fda1201a72d6c3d5ea"
    sha256 cellar: :any_skip_relocation, mojave:        "9832ceb97e387a519d6ae9b66bb3a7066c1d112d947667527a5edfcc692e4983"
    sha256 cellar: :any_skip_relocation, high_sierra:   "26e39af069485ef58c3517fb765db3a5e8dba0f253aac3d0d5968ff2a35e595b"
  end

  depends_on "libtool" => :build

  # Fixes mp_set_double being missing on macOS.
  # This is needed by some dependents in homebrew-core.
  # NOTE: This patch has been merged upstream but we take a backport
  # from a fork due to file name differences between 1.2.0 and master.
  # Remove with the next version.
  patch do
    url "https://github.com/MoarVM/libtommath/commit/db0d387b808d557bd408a6a253c5bf3a688ef274.patch?full_index=1"
    sha256 "e5eef1762dd3e92125e36034afa72552d77f066eaa19a0fd03cd4f1a656f9ab0"
  end

  def install
    ENV["DESTDIR"] = prefix

    system "make", "-f", "makefile.shared", "install"
    system "make", "test"
    pkgshare.install "test"
  end

  test do
    system pkgshare/"test"
  end
end
