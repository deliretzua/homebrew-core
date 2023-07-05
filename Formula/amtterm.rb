class Amtterm < Formula
  desc "Serial-over-LAN (sol) client for Intel AMT"
  homepage "https://www.kraxel.org/blog/linux/amtterm/"
  url "https://www.kraxel.org/releases/amtterm/amtterm-1.7.tar.gz"
  sha256 "8c58b76b3237504d751bf3588fef25117248a0569523f0d86deaf696d14294d4"
  license "GPL-2.0-or-later"
  head "https://git.kraxel.org/git/amtterm/", branch: "master", using: :git

  livecheck do
    url "https://www.kraxel.org/releases/amtterm/"
    regex(/href=.*?amtterm[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "48558be96b4a9b8e93d2df1bf55c3b525692ae0a6cec72f22bb222c5debf5073"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a59e80adf7dd88384f4020c67177de6876f431769b7bd3274759b29bda7204b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7130d5cc879edc7425791e096234f76891e742ebcfcc5c9a7043ebad0fbf8afd"
    sha256 cellar: :any_skip_relocation, ventura:        "ef2e287abf3b6674d877ea82dd465c47e536e0f0d6ae7c0c69d991647da8290a"
    sha256 cellar: :any_skip_relocation, monterey:       "c4380ecc8551ea99925203823a63706e8ecdd23b010459528b7a3efc8acb8169"
    sha256 cellar: :any_skip_relocation, big_sur:        "3de2c8131b610bcf1d4d9cf1bb537d2a66b19dbc49e76f26e0ca280e48c1827c"
    sha256 cellar: :any_skip_relocation, catalina:       "ed7067b9e98f43c6a13bd5dc43b5467508e33f209399b4e276da21091ae74907"
    sha256 cellar: :any_skip_relocation, mojave:         "aab6ab711f9b407ef0df77a386b005cc8d10f7c0fb3c9c581659fea65e0edd00"
    sha256 cellar: :any_skip_relocation, high_sierra:    "29180333af292e440f077a00a958ceb6f0035bcee9945233bc33177d0b3549f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8508f3178996f322def37aa3bdce2573379e73682c5393fb6e952f18fdfbc22c"
  end

  depends_on "gtk+3"
  depends_on :linux
  depends_on "vte3"

  resource "SOAP::Lite" do
    url "https://cpan.metacpan.org/authors/id/P/PH/PHRED/SOAP-Lite-1.27.tar.gz"
    sha256 "e359106bab1a45a16044a4c2f8049fad034e5ded1517990bc9b5f8d86dddd301"
  end

  def install
    ENV.prepend_create_path "PERL5LIB", libexec/"lib/perl5"

    resource("SOAP::Lite").stage do
      system "perl", "Makefile.PL", "INSTALL_BASE=#{libexec}"
      system "make"
      system "make", "install"
    end

    # @echo -e accidentally prepends "-e" to the beginning of Make.config
    # which causes the build to fail with an "empty variable" error.
    inreplace "mk/Autoconf.mk", "@echo -e", "@echo"

    system "make", "prefix=#{prefix}", "install"
    bin.env_script_all_files(libexec+"bin", PERL5LIB: ENV["PERL5LIB"])
  end

  test do
    assert_match "Connection refused", shell_output("#{bin}/amtterm 127.0.0.1 -u brew -p brew 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/amtterm -v 2>&1", 1)
  end
end
