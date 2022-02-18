class Gpgme < Formula
  desc "Library access to GnuPG"
  homepage "https://www.gnupg.org/related_software/gpgme/"
  url "https://www.gnupg.org/ftp/gcrypt/gpgme/gpgme-1.17.0.tar.bz2"
  sha256 "4ed3f50ceb7be2fce2c291414256b20c9ebf4c03fddb922c88cda99c119a69f5"
  license "LGPL-2.1-or-later"

  livecheck do
    url "https://gnupg.org/ftp/gcrypt/gpgme/"
    regex(/href=.*?gpgme[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b732123358ed02a82a0d42a2a7f4adc0ead134196da5ed522f5d86610cca8e95"
    sha256 cellar: :any,                 arm64_big_sur:  "a6408468cf32338ff783f685eea507a779b63f21aa1074e8be250088832de2fb"
    sha256 cellar: :any,                 monterey:       "fe3c49857c2badaade514c1e3083542309777916c1a309e97f933043d9dcfd38"
    sha256 cellar: :any,                 big_sur:        "93ef1638eedcb613c2d4992917c081409985aba3d20db3a3c5bbd9b02e008ee3"
    sha256 cellar: :any,                 catalina:       "4d51fe3ce646233005f33c6f53fd50e2111dfa21891b03d4cce9ce3845da2373"
    sha256 cellar: :any,                 mojave:         "5f69a086be935cd7f1994bc709a1510e5c3182865240bf32c9ef1d7ea8cd82dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8d96889a4f0d9e5098a59f6c76d1dd42fe4cf5232d7db748754c73576c639c8a"
  end

  depends_on "python@3.9" => [:build, :test]
  depends_on "swig" => :build
  depends_on "gnupg"
  depends_on "libassuan"
  depends_on "libgpg-error"

  def install
    ENV["PYTHON"] = which("python3")
    # setuptools>=60 prefers its own bundled distutils, which breaks the installation
    # Remove when distutils is no longer used. Related PR: https://dev.gnupg.org/D545
    ENV["SETUPTOOLS_USE_DISTUTILS"] = "stdlib"

    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-static"
    system "make"
    system "make", "install"

    # avoid triggering mandatory rebuilds of software that hard-codes this path
    inreplace bin/"gpgme-config", prefix, opt_prefix
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gpgme-tool --lib-version")
    system Formula["python@3.9"].opt_bin/"python3", "-c", "import gpg; print(gpg.version.versionstr)"
  end
end
