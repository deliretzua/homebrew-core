class LinkGrammar < Formula
  desc "Carnegie Mellon University's link grammar parser"
  homepage "https://github.com/opencog/link-grammar"
  url "https://github.com/opencog/link-grammar/archive/refs/tags/link-grammar-5.12.3.tar.gz"
  sha256 "e0cd1b94cc9af20e5bd9a04604a714e11efe21ae5e453b639cdac050b6ac4150"
  license "LGPL-2.1-or-later"
  head "https://github.com/opencog/link-grammar.git", branch: "master"

  bottle do
    rebuild 1
    sha256 arm64_ventura:  "2c31cb487824194c544a214126322ed94a57a72a69ef38cc0559eeb1ad6d0812"
    sha256 arm64_monterey: "92804926f22e3c18ea5c91a350733119c8289d0dfd93d8d765b31adb7f2ac609"
    sha256 arm64_big_sur:  "2ef75de9f6d569875a2915b80886489f394eeb07e314446cf259b93f4ae75b44"
    sha256 ventura:        "02d685eefef2ab0d1abbfa39d3d056396935a4b8aceb5b65d947c1f612425dcd"
    sha256 monterey:       "9e222666ce37a53fdd9a48518dde6bade154756745eacee0a75262bdf7a3f049"
    sha256 big_sur:        "6292300861193d494192f6d091b99b672ee64da5e055dc68bb1fe2ca686ecb75"
    sha256 x86_64_linux:   "fa817e709e27ce5ea0cc86104b7daa072e72694b9c79510f56373b9636c2a134"
  end

  depends_on "ant" => :build
  depends_on "autoconf" => :build
  depends_on "autoconf-archive" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "swig" => :build

  uses_from_macos "flex" => :build
  uses_from_macos "libedit"
  uses_from_macos "sqlite"

  # upstream build patch ref, https://github.com/opencog/link-grammar/pull/1473
  patch do
    url "https://raw.githubusercontent.com/Homebrew/formula-patches/6de1efe/link-grammar/5.12.3.patch"
    sha256 "20d2c503ee2b50198d09ce5b69e39b4b88d9e8df849621e7b9f493f45c78ed1d"
  end

  def install
    # Workaround for Xcode 14.3.
    ENV.append_to_cflags "-Wno-implicit-function-declaration"

    ENV["PYTHON_LIBS"] = "-undefined dynamic_lookup"
    inreplace "bindings/python/Makefile.am", "$(PYTHON_LDFLAGS) -module -no-undefined",
                                             "$(PYTHON_LDFLAGS) -module"
    system "autoreconf", "--verbose", "--install", "--force"
    system "./configure", *std_configure_args, "--with-regexlib=c"

    # Work around error due to install using detected path inside Python formula.
    # install: .../site-packages/linkgrammar.pth: Operation not permitted
    site_packages = prefix/Language::Python.site_packages("python3.11")
    system "make", "install", "pythondir=#{site_packages}",
                              "pyexecdir=#{site_packages}"
  end

  test do
    system "#{bin}/link-parser", "--version"
  end
end
