# NOTE: Mutt has a large number of non-upstream patches available for
# it, some of which conflict with each other. These patches are also
# not kept up-to-date when new versions of mutt (occasionally) come
# out.
#
# To reduce Homebrew's maintenance burden, patches are not accepted
# for this formula. The NeoMutt project has a Homebrew tap for their
# patched version of Mutt: https://github.com/neomutt/homebrew-neomutt

class Mutt < Formula
  desc "Mongrel of mail user agents (part elm, pine, mush, mh, etc.)"
  homepage "http://www.mutt.org/"
  url "https://bitbucket.org/mutt/mutt/downloads/mutt-2.0.6.tar.gz"
  sha256 "81e31c45895fd624747f19106aa2697d2aa135049ff2e9e9db0a6ed876bcb598"
  license "GPL-2.0-or-later"

  bottle do
    sha256 arm64_big_sur: "a32a3bcde99e16e0b16162fe404f5abc11602435ecf1cc00fb11dad1b36ef77b"
    sha256 big_sur:       "0c0b14055a9fc4642b056e08ef4efd7fdb60502f1f1bcb1fa3f6a09db75345e4"
    sha256 catalina:      "4a17ba5b145010cffadd61078a1f76868b8f877ec50ff12bea5556a6c377f30b"
    sha256 mojave:        "c68e78ed55fa03921ba839b0b15cd25ecc53b6955f6a691450ec206b9142b73a"
  end

  head do
    url "https://gitlab.com/muttmua/mutt.git"

    resource "html" do
      url "https://muttmua.gitlab.io/mutt/manual-dev.html"
    end
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "gpgme"
  depends_on "openssl@1.1"
  depends_on "tokyo-cabinet"

  uses_from_macos "bzip2"
  uses_from_macos "krb5"
  uses_from_macos "ncurses"
  uses_from_macos "zlib"

  conflicts_with "tin",
    because: "both install mmdf.5 and mbox.5 man pages"

  def install
    user_in_mail_group = Etc.getgrnam("mail").mem.include?(ENV["USER"])
    effective_group = Etc.getgrgid(Process.egid).name

    args = %W[
      --disable-dependency-tracking
      --disable-warnings
      --prefix=#{prefix}
      --enable-debug
      --enable-hcache
      --enable-imap
      --enable-pop
      --enable-sidebar
      --enable-smtp
      --with-gss
      --with-sasl
      --with-ssl=#{Formula["openssl@1.1"].opt_prefix}
      --with-tokyocabinet
      --enable-gpgme
    ]

    system "./prepare", *args
    system "make"

    # This permits the `mutt_dotlock` file to be installed under a group
    # that isn't `mail`.
    # https://github.com/Homebrew/homebrew/issues/45400
    inreplace "Makefile", /^DOTLOCK_GROUP =.*$/, "DOTLOCK_GROUP = #{effective_group}" unless user_in_mail_group

    system "make", "install"
    doc.install resource("html") if build.head?
  end

  def caveats
    <<~EOS
      mutt_dotlock(1) has been installed, but does not have the permissions to lock
      spool files in /var/mail. To grant the necessary permissions, run

        sudo chgrp mail #{bin}/mutt_dotlock
        sudo chmod g+s #{bin}/mutt_dotlock

      Alternatively, you may configure `spoolfile` in your .muttrc to a file inside
      your home directory.
    EOS
  end

  test do
    system bin/"mutt", "-D"
    touch "foo"
    system bin/"mutt_dotlock", "foo"
    system bin/"mutt_dotlock", "-u", "foo"
  end
end
