class Gopass < Formula
  desc "Slightly more awesome Standard Unix Password Manager for Teams"
  homepage "https://github.com/gopasspw/gopass"
  url "https://github.com/gopasspw/gopass/releases/download/v1.12.2/gopass-1.12.2.tar.gz"
  sha256 "b4254ecbc14b62a68e1e98c99d08d53c50a5b5b15b8b5b592266a6d581c93f13"
  license "MIT"
  revision 2
  head "https://github.com/gopasspw/gopass.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a21d4f0ea78429dfe7350ba849add31cd0bbff1f26d569206924d1f705870b5f"
    sha256 cellar: :any_skip_relocation, big_sur:       "d18b4ff21f9de549a49d7baad298184706aecf4d0ab228a15c4a46a92ce0faf1"
    sha256 cellar: :any_skip_relocation, catalina:      "4df56d76be3ef1d54a5244205b545351a64af8dfca2fc6c832be94a2b205fcee"
    sha256 cellar: :any_skip_relocation, mojave:        "5bc755a971461724f3ee6b1c15854b88b1bfde61ae80d51f6a1c58676f539317"
  end

  depends_on "go" => :build
  depends_on "gnupg"

  on_macos do
    depends_on "terminal-notifier"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}/"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gopass version")

    (testpath/"batch.gpg").write <<~EOS
      Key-Type: RSA
      Key-Length: 2048
      Subkey-Type: RSA
      Subkey-Length: 2048
      Name-Real: Testing
      Name-Email: testing@foo.bar
      Expire-Date: 1d
      %no-protection
      %commit
    EOS
    begin
      system Formula["gnupg"].opt_bin/"gpg", "--batch", "--gen-key", "batch.gpg"

      system bin/"gopass", "init", "--path", testpath, "noop", "testing@foo.bar"
      system bin/"gopass", "generate", "Email/other@foo.bar", "15"
      assert_predicate testpath/"Email/other@foo.bar.gpg", :exist?
    ensure
      system Formula["gnupg"].opt_bin/"gpgconf", "--kill", "gpg-agent"
      system Formula["gnupg"].opt_bin/"gpgconf", "--homedir", "keyrings/live",
                                                 "--kill", "gpg-agent"
    end
  end
end
