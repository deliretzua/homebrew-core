class Utftex < Formula
  desc "Pretty print math in monospace fonts, using a TeX-like syntax"
  homepage "https://github.com/bartp5/libtexprintf"
  url "https://github.com/bartp5/libtexprintf/archive/refs/tags/v1.18.tar.gz"
  sha256 "ff39c33629ae9bc6f8782b9fdfa14a240a75ee3a3bf80d02f95bf31c522f9e31"
  license "GPL-3.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3a4da71f7f027ba3a2276bb9eb0db3bc915fc5216a694e3308d7eb5432e2dd5e"
    sha256 cellar: :any,                 arm64_monterey: "80f2a270a1af94beddc7cbaafb1376ffb5bceb2a968f40bb711bf181a58107b7"
    sha256 cellar: :any,                 arm64_big_sur:  "57c6f6a6351522ea6518359bd78917aaa859c26d7a63d62062aeb03ce55aef35"
    sha256 cellar: :any,                 ventura:        "660fa6e66d45a758864d5f2735bc8d79c7f2ea997074142da2f77d6cd0f2b93c"
    sha256 cellar: :any,                 monterey:       "8a89f30618815e1bfd567f39e8c23fd8f80d7df8dbc2da75f1edf6ab4f4ec4a7"
    sha256 cellar: :any,                 big_sur:        "8ee1912853bc53d698dbb3cfadfaf71db746e62601fc1ee5d4362eff9a9d133e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6ec676912901c26bc8f6b453d3c0f9cdc5f041ea29d2b3ceda50e24bd91e8451"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  # Fixes race condition in Makefile
  # Remove in next release
  patch do
    url "https://github.com/bartp5/libtexprintf/commit/65fb91ab307f3185278fca354f21f4c282cc7154.patch?full_index=1"
    sha256 "23d67a77fc27ecfb7c9c600db2eeb58eb78fe0ef1d23e00415e9cc08fdd1620a"
  end

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args, "--disable-silent-rules"
    system "make", "install"
  end

  test do
    system bin/"utftex", "\\left(\\frac{hello}{world}\\right)"
  end
end
