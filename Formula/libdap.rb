class Libdap < Formula
  desc "Framework for scientific data networking"
  homepage "https://www.opendap.org/"
  license "LGPL-2.1-or-later"
  revision 1

  stable do
    # TODO: Update deps and `install` method when libtirpc patch on Linux is no longer needed.
    url "https://www.opendap.org/pub/source/libdap-3.20.11.tar.gz"
    sha256 "850debf6ee6991350bf31051308093bee35ddd2121e4002be7e130a319de1415"

    # Fix flat namespace flag on Big Sur+.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://www.opendap.org/pub/source/"
    regex(/href=.*?libdap[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_ventura:  "93b76a54876a5ce5bea5ae9725bbd7a463aacb3b381da12a5882833056276033"
    sha256 arm64_monterey: "0110dd93e378ea92ffdb3ef93a55e6f0318b0213afc47c34672167ef3838569e"
    sha256 arm64_big_sur:  "0bb35b663ee9c9ee835781a2b3fd370d4af6342673d64e90791e6e673a9f2d5f"
    sha256 ventura:        "f18048bb918f094371b1f4db3edbce07c59a7fe795e118f4047a940e18e8384a"
    sha256 monterey:       "74a2d396f08b072b0255351185d5cd1fab6ec822fb267d55ee969aec41a1266a"
    sha256 big_sur:        "242e4b6903097098b4a11c95fe1dbd7431b19071db1c27876073437a054b69b3"
    sha256 catalina:       "a40f6f6812a65cf3a16f5f8f49a6435e9bd97b8fe8d08f9484ead497be2eae79"
    sha256 x86_64_linux:   "be215472473e21ed6763ad8591131295752813704039e816a415045f1f82101e"
  end

  head do
    url "https://github.com/OPENDAP/libdap4.git", branch: "master"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  depends_on "bison" => :build
  depends_on "pkg-config" => :build
  depends_on "libxml2"
  depends_on "openssl@3"

  uses_from_macos "flex" => :build
  uses_from_macos "curl"

  on_linux do
    # TODO: `autoconf`, `automake`, and `libtool` are needed for the libtirpc patch.
    #       Remove when patch is no longer needed.
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "libtirpc"
    depends_on "util-linux"

    # Fix finding libtirpc on Linux.
    # https://github.com/OPENDAP/libdap4/pull/228
    patch do
      url "https://github.com/OPENDAP/libdap4/commit/48b44b96faf1ed1e44f118828c3de903fff0a276.patch?full_index=1"
      sha256 "b11c233844691b97d2eab208a49d520ad9d78ce6d14ca52bb5fdad29b5db1f37"
    end
  end

  def install
    args = %W[
      --prefix=#{prefix}
      --disable-dependency-tracking
      --disable-debug
      --with-included-regex
    ]

    # Remove `OS.linux? || ` when Linux libtirpc patch is no longer needed.
    system "autoreconf", "--force", "--install", "--verbose" if OS.linux? || build.head?
    system "./configure", *args
    system "make"
    system "make", "check"
    system "make", "install"

    # Ensure no Cellar versioning of libxml2 path in dap-config entries
    xml2 = Formula["libxml2"]
    inreplace bin/"dap-config", xml2.opt_prefix.realpath, xml2.opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dap-config --version")
  end
end
