class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  # TODO: Remove `autoconf`, `automake` and `libtool` dependencies when the patch is removed.
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.3.tar.gz"
  sha256 "8c78f82ae959a900f47c7319cbf7688182cde39dcc4c4b9aa399a142be4dc143"
  license "ISC"

  bottle do
    sha256 arm64_ventura:  "68a2394a47e424d5d218407ef2e7a13486c3a41b63851ee490a314af6d3a1c67"
    sha256 arm64_monterey: "5e6403874007d3bc810a048fdb839310df6e5f19539c1ab4f4692101d10e3131"
    sha256 arm64_big_sur:  "ec6f3dda6f8c51227aef2af0efba137b2b64f998f134c88abc3776c5b1d68430"
    sha256 ventura:        "293a75b60c4069562cf6c836eab505bdbc282050b6c866029cccd548e06bbe5c"
    sha256 monterey:       "e9ea8b936428ad9685f7b7534b79db17bf68a46ed14601d3781e5a3f796fa81d"
    sha256 big_sur:        "4d409a946b1efb77e0667cd93aa5f62284db34a3f3800e99759f89cf59b9f9e6"
    sha256 x86_64_linux:   "90f625188abd2191d12b7b0a4f4304910071b15aca3aef0b8a2003db62d7a142"
  end

  # We need `autoconf`, `automake` and `libtool` to apply the patch below.
  # Remove when the patch is no longer needed.
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "libretls"
  depends_on "openssl@3"
  depends_on "rsync"

  uses_from_macos "expat"

  # Fix absence of `HOST_NAME_MAX` on macOS.
  # Remove in next release.
  patch do
    url "https://github.com/rpki-client/rpki-client-portable/commit/65e5d4b99131b7cc8091ea222b70d24ec04fac60.patch?full_index=1"
    sha256 "014b522efa2f656853b42673ac7bf592ed662468d911b251c918b0154bac0a3d"
  end

  def install
    # We call `autoreconf` because we apply a patch. Remove when the patch is no longer needed.
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", *std_configure_args,
                          "--with-rsync=#{Formula["rsync"].opt_bin}/rsync",
                          "--disable-silent-rules",
                          "--sysconfdir=#{etc}",
                          "--localstatedir=#{var}"
    system "make", "install"
  end

  def post_install
    # make the var/db,cache/rpki-client dirs
    (var/"db/rpki-client").mkpath
    (var/"cache/rpki-client").mkpath
  end

  test do
    assert_match "VRP Entries: 0 (0 unique)", shell_output("#{sbin}/rpki-client -n -d . -R . 2>&1")
    assert_match "rpki-client-portable #{version}", shell_output("#{sbin}/rpki-client -V 2>&1")
  end
end
