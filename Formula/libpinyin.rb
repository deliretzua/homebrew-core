class Libpinyin < Formula
  desc "Library to deal with pinyin"
  homepage "https://github.com/libpinyin/libpinyin"
  url "https://github.com/libpinyin/libpinyin/archive/2.8.1.tar.gz"
  sha256 "42c4f899f71fc26bcc57bb1e2a9309c2733212bb241a0008ba3c9b5ebd951443"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "0ad30a7fa33d9c0a1c8581c2419503d1d78b003ddcee423c37bac04cafe93c8b"
    sha256 cellar: :any,                 arm64_big_sur:  "27a64914df992d5c46d8b48b857330192efd499b68e9b14530209f38dbeff6f7"
    sha256 cellar: :any,                 monterey:       "17c216d7bb3b88f0949728385f2fb6c34192c7237bfccacffdab2e3fa66f25db"
    sha256 cellar: :any,                 big_sur:        "04aef79d829825812370a7f379d2c4fc71295cc44b55836dee114695cca1c774"
    sha256 cellar: :any,                 catalina:       "0bee752e798e97e0d6e49686e87b68004858dacbcd3117c11d7ee4187961d200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b4d994fc8832b0919775a0e16f769fe8d1a2e5ea82227c1012b5cdf6a0c8bb7"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  # macOS `ld64` does not like the `.la` files created during the build.
  # upstream issue report, https://github.com/libpinyin/libpinyin/issues/158
  depends_on "llvm" => :build if DevelopmentTools.clang_build_version >= 1400
  depends_on "pkg-config" => :build
  depends_on "berkeley-db"
  depends_on "glib"

  # The language model file is independently maintained by the project owner.
  # To update this resource block, the URL can be found in data/Makefile.am.
  resource "model" do
    url "https://downloads.sourceforge.net/libpinyin/models/model19.text.tar.gz"
    sha256 "56422a4ee5966c2c809dd065692590ee8def934e52edbbe249b8488daaa1f50b"
  end

  def install
    # Workaround for Xcode 14 ld.
    ENV.append_to_cflags "-fuse-ld=lld" if DevelopmentTools.clang_build_version >= 1400

    resource("model").stage buildpath/"data"
    system "./autogen.sh", "--enable-libzhuyin=yes",
                           "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"test.cc").write <<~EOS
      #include <pinyin.h>

      int main()
      {
          pinyin_context_t * context = pinyin_init (LIBPINYIN_DATADIR, "");

          if (context == NULL)
              return 1;

          pinyin_instance_t * instance = pinyin_alloc_instance (context);

          if (instance == NULL)
              return 1;

          pinyin_free_instance (instance);

          pinyin_fini (context);

          return 0;
      }
    EOS
    glib = Formula["glib"]
    flags = %W[
      -I#{include}/libpinyin-#{version}
      -I#{glib.opt_include}/glib-2.0
      -I#{glib.opt_lib}/glib-2.0/include
      -L#{lib}
      -L#{glib.opt_lib}
      -DLIBPINYIN_DATADIR="#{lib}/libpinyin/data/"
      -lglib-2.0
      -lpinyin
    ]
    system ENV.cxx, "test.cc", "-o", "test", *flags
    touch "user.conf"
    system "./test"
  end
end
