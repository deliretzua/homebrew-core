class StripNondeterminism < Formula
  desc "Tool for stripping bits of non-deterministic information from files"
  homepage "https://salsa.debian.org/reproducible-builds/strip-nondeterminism"
  url "https://salsa.debian.org/reproducible-builds/strip-nondeterminism/-/archive/1.13.1/strip-nondeterminism-1.13.1.tar.bz2"
  sha256 "0bde4b23edd6cdb82fcdc4745ef9dc8ca0743e7c7e4fb2ea0bf78c76511f49f3"
  license "GPL-3.0-or-later"
  head "https://salsa.debian.org/reproducible-builds/strip-nondeterminism.git", branch: "master"

  uses_from_macos "file-formula" => :test
  uses_from_macos "perl"

  resource "Archive::Cpio" do
    url "https://cpan.metacpan.org/authors/id/P/PI/PIXEL/Archive-Cpio-0.10.tar.gz"
    sha256 "246fb31669764e78336b2191134122e07c44f2d82dc4f37d552ab28f8668bed3"
  end

  resource "Archive::Zip" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/Archive-Zip-1.68.tar.gz"
    sha256 "984e185d785baf6129c6e75f8eb44411745ac00bf6122fb1c8e822a3861ec650"
  end

  resource "Getopt::Long" do
    url "https://cpan.metacpan.org/authors/id/J/JV/JV/Getopt-Long-2.54.tar.gz"
    sha256 "584ba3c99bb2d6b341375212f9b874613f706cfb01cee21b8a2676a98ab985fe"
  end

  resource "Sub::Override" do
    url "https://cpan.metacpan.org/authors/id/O/OV/OVID/Sub-Override-0.09.tar.gz"
    sha256 "939a67c1f729968e0cc81b74958db750e1bdb7c020bee1a263332f422c2e25b5"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"
    ENV.prepend_path "PERL5LIB", libexec/"lib"

    resources.each do |r|
      r.stage do
        if File.exist?("Makefile.PL")
          system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}", "NO_MYMETA=1"
          system "make", "install"
        else
          system "perl", "Build.PL", "--install_base", libexec
          system "./Build"
          system "./Build", "install"
        end
      end
    end

    system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
    system "make"
    system "make", "install"

    (bin/"strip-nondeterminism").write_env_script libexec/"bin/strip-nondeterminism", PERL5LIB: ENV["PERL5LIB"]
    man1.install_symlink libexec/"man/man1/strip-nondeterminism.1"
  end

  test do
    (testpath/"test.txt").write "Hello world"
    system "gzip", "test.txt"
    system bin/"strip-nondeterminism", "--timestamp", "1", "--verbose", "test.txt.gz"
    assert_match(/Thu\s+Jan\s+1\s+00:00:01\s+1970/, shell_output("file test.txt.gz"))
  end
end
