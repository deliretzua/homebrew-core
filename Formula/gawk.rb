class Gawk < Formula
  desc "GNU awk utility"
  homepage "https://www.gnu.org/software/gawk/"
  url "https://ftp.gnu.org/gnu/gawk/gawk-5.2.1.tar.xz"
  mirror "https://ftpmirror.gnu.org/gawk/gawk-5.2.1.tar.xz"
  sha256 "673553b91f9e18cc5792ed51075df8d510c9040f550a6f74e09c9add243a7e4f"
  license "GPL-3.0-or-later"
  head "https://git.savannah.gnu.org/git/gawk.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "6b4cee627ba48875cb56511c3a18a09bff2a763765e186b32b680c07880ab32c"
    sha256 arm64_monterey: "6289d1f8da329535dcb50a610286cd4ec29225668df5d55b7d0fc25592ad4a1a"
    sha256 arm64_big_sur:  "18af9a141a7e82895f2f578d376fdecfb3924144872e9d1e86085785745f8472"
    sha256 ventura:        "5f2410c52d819fc1863692f2f0aa9030aa0e2ba9904b2d604b888f367425ffd7"
    sha256 monterey:       "21b5da026357aeb9a588da81c1170ed256fd9084fbf2fda489db3deb03bbe90c"
    sha256 big_sur:        "2e16ae3da305c804a65c41020a29fbea76bc4f8b61bb6b67a983d0dc37c8cd3b"
    sha256 catalina:       "86f7f8308a0fb9152e6272f8569f5bb9384f47a15f57c3bdd41d6334838fe74b"
    sha256 x86_64_linux:   "29b8be1d8bb275b8a82747490c29472fea3a7fc0b4bd345c0c72f3abe8c4b4be"
  end

  depends_on "gettext"
  depends_on "mpfr"
  depends_on "readline"

  conflicts_with "awk",
    because: "both install an `awk` executable"

  def install
    system "./bootstrap.sh" if build.head?

    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --without-libsigsegv-prefix
    ]
    # Persistent memory allocator (PMA) is enabled by default. At the time of
    # writing, that would force an x86_64 executable on macOS arm64, because a
    # native ARM binary with such feature would not work. See:
    # https://git.savannah.gnu.org/cgit/gawk.git/tree/README_d/README.macosx?h=gawk-5.2.1#n1
    args << "--disable-pma" if OS.mac? && Hardware::CPU.arm?
    system "./configure", *args

    system "make"
    if which "cmp"
      system "make", "check"
    else
      opoo "Skipping `make check` due to unavailable `cmp`"
    end
    system "make", "install"

    (libexec/"gnubin").install_symlink bin/"gawk" => "awk"
    (libexec/"gnuman/man1").install_symlink man1/"gawk.1" => "awk.1"
    libexec.install_symlink "gnuman" => "man"
  end

  test do
    output = pipe_output("#{bin}/gawk '{ gsub(/Macro/, \"Home\"); print }' -", "Macrobrew")
    assert_equal "Homebrew", output.strip
  end
end
