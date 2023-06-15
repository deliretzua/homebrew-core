class GuileGnutls < Formula
  desc "Guile bindings for the GnuTLS library"
  homepage "https://gitlab.com/gnutls/guile"
  url "https://gitlab.com/gnutls/guile/uploads/3fe12c208bdc6155c5116cf5eac7a2ad/guile-gnutls-3.7.12.tar.gz"
  sha256 "5d3af11573093de59f258415872e2c5b14cca9dd251a8b2ec1643d6e97fee336"
  license "LGPL-2.1-or-later"
  head "https://gitlab.com/gnutls/guile.git", branch: "master"

  bottle do
    sha256 arm64_ventura:  "b6d7ac219f5e8d56837e23ddc464c52b2b67ac2882299bfa701aaa8031b67e91"
    sha256 arm64_monterey: "7210aee9ee2a18efc75c467c68acbcf55efd3800e4332fdb5df65730823557b3"
    sha256 arm64_big_sur:  "3ac57390d3bf3ef51aac3d4f467605f40b0c19d2148335ee6bb2cd71b404602c"
    sha256 ventura:        "c3b01474a5c7290941eca2f804f020b64f9ceb8fef11620a0049b850c6f42433"
    sha256 monterey:       "cf51af65c57ab9b8678119b54c1e55a4decb0e35f1106653e8a9956b1d96cf51"
    sha256 big_sur:        "a510c4971d1fe13d53912027a0266ebd721ab33b39cce0463c2ec3d4b9492cde"
    sha256 x86_64_linux:   "40cd417f6ffe15e1f74d85f6c23753a2eff3ac704be74d470e326ededf2f4581"
  end

  depends_on "gnutls"
  depends_on "guile"

  def install
    # configure: WARNING: unrecognized options: --disable-debug
    system "./configure", "--prefix=#{prefix}",
                          "--with-guile-site-dir=#{share}/guile/site/3.0",
                          "--with-guile-site-ccache-dir=#{lib}/guile/3.0/site-ccache",
                          "--with-guile-extension-dir=#{lib}/guile/3.0/extensions",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules"
    system "make", "install"
  end

  def post_install
    # Touch gnutls.go to avoid Guile recompilation.
    # See https://github.com/Homebrew/homebrew-core/pull/60307#discussion_r478917491
    touch lib/"guile/3.0/site-ccache/gnutls.go"
  end

  def caveats
    <<~EOS
      If you are going to use the Guile bindings you will need to add the following
      to your .bashrc or equivalent in order for Guile to find the TLS certificates
      database:
        export GUILE_TLS_CERTIFICATE_DIRECTORY=#{Formula["gnutls"].pkgetc}/
    EOS
  end

  test do
    gnutls = testpath/"gnutls.scm"
    gnutls.write <<~EOS
      (use-modules (gnutls))
      (gnutls-version)
    EOS

    ENV["GUILE_AUTO_COMPILE"] = "0"
    ENV["GUILE_LOAD_PATH"] = HOMEBREW_PREFIX/"share/guile/site/3.0"
    ENV["GUILE_LOAD_COMPILED_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/site-ccache"
    ENV["GUILE_SYSTEM_EXTENSIONS_PATH"] = HOMEBREW_PREFIX/"lib/guile/3.0/extensions"

    system "guile", gnutls
  end
end
