class Psutils < Formula
  desc "Utilities for manipulating PostScript documents"
  homepage "https://github.com/rrthomas/psutils"
  url "https://github.com/rrthomas/psutils/releases/download/v2.10/psutils-2.10.tar.gz"
  sha256 "6f8339fd5322df5c782bfb355d9f89e513353220fca0700a5a28775404d7e98b"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "bb268fd6eb5dd600ae0c81387e8a88a074f68a1ffde072a3e2ac387e142449e4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8d31594cd841f9c3fab5b2d57b7562f27614e91b88c0021f2d6132d4100f3133"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02cd6e56f1a40d01069ee8d59ceafdab15e0c9ec6c75873f845f2588df87d31c"
    sha256 cellar: :any_skip_relocation, ventura:        "8046101881e3fb43865364afc706a0b75283f83fc312414d8f9b5a2cdaa8fbb1"
    sha256 cellar: :any_skip_relocation, monterey:       "5531ac88d24275129272f8e0c14f185ff06cd114f4c530624d1d436bd4e4df54"
    sha256 cellar: :any_skip_relocation, big_sur:        "229bde3f399638b21570063c1586fce976f4498475901f28bce30546a4e60220"
    sha256 cellar: :any_skip_relocation, catalina:       "c2aed2811e263c3e3abcf66eb27d6fdd1b622ca033fa2e3bf4e8095c733df08a"
    sha256 cellar: :any_skip_relocation, mojave:         "d2ba48c88116be774d989d71c791ef97f8eac3723e63a0924e08ea48f4b3ab39"
    sha256 cellar: :any_skip_relocation, high_sierra:    "d9408c8f70db105a621195339f357107d6f234c75be581b1ca8365d0e82e62c2"
    sha256 cellar: :any_skip_relocation, sierra:         "1319662888a509ceee3993bf17e7fb2f9dfaea5ce25c983c0bcda13283b5d612"
    sha256 cellar: :any_skip_relocation, el_capitan:     "def5b3fc8cef9b4c532cc26ae216d1c6b0dae54da5a39acbdb818d53a04bf697"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3596c25429993fbcfa470fae16bafaa3da785fb610cacf9063d2b8ee26300d42"
  end

  depends_on "libpaper"

  uses_from_macos "perl"

  resource "IPC::Run3" do
    on_linux do
      url "https://cpan.metacpan.org/authors/id/R/RJ/RJBS/IPC-Run3-0.048.tar.gz"
      sha256 "3d81c3cc1b5cff69cca9361e2c6e38df0352251ae7b41e2ff3febc850e463565"
    end
  end

  def install
    if OS.linux?
      ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
      resource("IPC::Run3").stage do
        system "perl", "Makefile.PL", "INSTALLSITELIB=#{pkgshare}"
        system "make"
        system "make", "install"
      end
    end

    system "./configure", *std_configure_args
    system "make", "install"
    pkgshare.install "tests/psbook-3-input.ps"
  end

  test do
    test_ps = pkgshare/"psbook-3-input.ps"
    system bin/"psbook", test_ps, "test.ps"
    system bin/"psnup", "-n", "2", test_ps, "nup.ps"
    system bin/"psselect", "-p1", test_ps, "test2.ps"
  end
end
