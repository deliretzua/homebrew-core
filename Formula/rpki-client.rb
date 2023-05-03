class RpkiClient < Formula
  desc "OpenBSD portable rpki-client"
  homepage "https://www.rpki-client.org/"
  url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/rpki-client-8.4.tar.gz"
  sha256 "cac9409566a98c7a89e4e08a1b0f377627d92b5e065f4066a2b4eb7fec7869c8"
  license "ISC"

  livecheck do
    url "https://ftp.openbsd.org/pub/OpenBSD/rpki-client/"
    regex(/href=.*?rpki-client[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "c0e289b603ba35475efe37a5e77898340f51053ee9552e4bcd3091b9c4bd48a1"
    sha256 arm64_monterey: "6fe2d161437b5ada9c7f434b7370bc9c3e520338d142931a4b00ca575c32349f"
    sha256 arm64_big_sur:  "9d9526100ccc7026d1c70489531b96b179c9a76fb6444eec4d70183d27086a57"
    sha256 ventura:        "88ac4c2b8189592d68ce7b9329398ec640b1ecd90216f15033e29c8c5ff48a7e"
    sha256 monterey:       "ea1324c9dc5f09b4cf64fdc421f14696dee0ad497a148c6f96c890c5d38e39c3"
    sha256 big_sur:        "9a3d781d801fd922d1b633bf967258f8329ddb6490918780507e935a9820a23b"
    sha256 x86_64_linux:   "ce7e879d64cb2909aa292f6478c8e04d73957dc70a7ffd42622fff4099a8bf79"
  end

  depends_on "pkg-config" => :build
  depends_on "libretls"
  depends_on "openssl@3"
  depends_on "rsync"

  uses_from_macos "expat"

  def install
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
