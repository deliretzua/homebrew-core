class AprUtil < Formula
  desc "Companion library to apr, the Apache Portable Runtime library"
  homepage "https://apr.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=apr/apr-util-1.6.3.tar.bz2"
  mirror "https://archive.apache.org/dist/apr/apr-util-1.6.3.tar.bz2"
  sha256 "a41076e3710746326c3945042994ad9a4fcac0ce0277dd8fea076fec3c9772b5"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 arm64_ventura:  "5ea1b08457b4f35362a0e8fc04508039da2c75020432b66e879fe2f29ad4f0a0"
    sha256 arm64_monterey: "a99d5cbb19fb70837640c2815cbd28203a60aac9e43d844e87c32d3a1f5a5882"
    sha256 arm64_big_sur:  "9ee165f6e45f9942b474ec8ede6daf54f83c8aec0d9e9c94ff5f94ffeded1d88"
    sha256 ventura:        "77a5ce9d0d7e39f5181a1a05b716c3beef0b9bcf167d9f0ff308a40ad3f3c6da"
    sha256 monterey:       "e222f66b4f62dd199c2682c945329585d605dadad38f3ce6b4c1bb311825fa8a"
    sha256 big_sur:        "5881ec4a073714f30439a9019e7d9f51cea1ff0d6e9a7d07f3420c592abec05f"
    sha256 x86_64_linux:   "495e178eaab5d989721170b12daadad737b4b827e1b7dcd0e3cabe156938fed8"
  end

  keg_only :shadowed_by_macos, "Apple's CLT provides apr (but not apr-util)"

  depends_on "apr"
  depends_on "openssl@3"

  uses_from_macos "expat"
  uses_from_macos "libxcrypt"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "mawk"
    depends_on "unixodbc"
  end

  def install
    system "./configure", *std_configure_args,
                          "--with-apr=#{Formula["apr"].opt_prefix}",
                          "--with-crypto",
                          "--with-openssl=#{Formula["openssl@1.1"].opt_prefix}",
                          "--without-pgsql"

    system "make"
    system "make", "install"

    # Install symlinks so that linkage doesn't break for reverse dependencies.
    # This should be removed on the next ABI breaking update.
    (libexec/"lib").install_symlink Dir["#{lib}/#{shared_library("*")}"]

    rm Dir[lib/"**/*.{la,exp}"]

    # No need for this to point to the versioned path.
    inreplace bin/"apu-#{version.major}-config", prefix, opt_prefix
  end

  test do
    assert_match opt_prefix.to_s, shell_output("#{bin}/apu-#{version.major}-config --prefix")
  end
end
