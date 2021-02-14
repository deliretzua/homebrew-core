class Liblockfile < Formula
  desc "Library providing functions to lock standard mailboxes"
  homepage "https://tracker.debian.org/pkg/liblockfile"
  url "https://deb.debian.org/debian/pool/main/libl/liblockfile/liblockfile_1.17.orig.tar.gz"
  sha256 "6e937f3650afab4aac198f348b89b1ca42edceb17fb6bb0918f642143ccfd15e"

  bottle do
    sha256 arm64_big_sur: "4fd8e00fafc2190ddfba9a3de861ce86b5ce3d9942ccaed88833e0a78589ac37"
    sha256 big_sur:       "c22eb6cb53066f5a9b16a60cf77a1b4980ad28b4f71f89a9e3c6bc5674c62b51"
    sha256 catalina:      "e5991a3eac0b5cd41f2850d73643607c33bb41b7014105f0ed80b75c5e7ef866"
    sha256 mojave:        "18663ff713cb46c514546f5a73026deb4e3df5b701b082b5cd68275581b05ba8"
    sha256 high_sierra:   "bc532693f97e4d14ac59974b80f5a31b121b5cc404efb2aacda1c1607f4bcf5b"
  end

  def install
    # brew runs without root privileges (and the group is named "wheel" anyway)
    inreplace "Makefile.in", " -g root ", " "

    system "./configure", "--disable-dependency-tracking",
                          "--disable-debug",
                          "--with-mailgroup=staff",
                          "--prefix=#{prefix}",
                          "--sysconfdir=#{etc}",
                          "--mandir=#{man}"
    bin.mkpath
    lib.mkpath
    include.mkpath
    man1.mkpath
    man3.mkpath
    system "make"
    system "make", "install"
  end

  test do
    system bin/"dotlockfile", "-l", "locked"
    assert_predicate testpath/"locked", :exist?
    system bin/"dotlockfile", "-u", "locked"
    refute_predicate testpath/"locked", :exist?
  end
end
