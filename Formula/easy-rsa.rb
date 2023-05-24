class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/archive/v3.1.4.tar.gz"
  sha256 "2366e1fae9defc1765661a654b53097a1930e3517fa706fe7524776aafc82016"
  license "GPL-2.0-only"
  head "https://github.com/OpenVPN/easy-rsa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "275929d5476598bfda955cd00488c5114596bdf0ea257b36fe6717bfdcb1736f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "275929d5476598bfda955cd00488c5114596bdf0ea257b36fe6717bfdcb1736f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "275929d5476598bfda955cd00488c5114596bdf0ea257b36fe6717bfdcb1736f"
    sha256 cellar: :any_skip_relocation, ventura:        "d80fac06906566d458f4a3ad9b8c3645d7bb348d1a677fb5513fed72c470d014"
    sha256 cellar: :any_skip_relocation, monterey:       "d80fac06906566d458f4a3ad9b8c3645d7bb348d1a677fb5513fed72c470d014"
    sha256 cellar: :any_skip_relocation, big_sur:        "d80fac06906566d458f4a3ad9b8c3645d7bb348d1a677fb5513fed72c470d014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "275929d5476598bfda955cd00488c5114596bdf0ea257b36fe6717bfdcb1736f"
  end

  depends_on "openssl@3"

  def install
    inreplace "easyrsa3/easyrsa", "'/etc/easy-rsa'", "'#{pkgetc}'"
    libexec.install "easyrsa3/easyrsa"
    (bin/"easyrsa").write_env_script libexec/"easyrsa",
      EASYRSA:         pkgetc,
      EASYRSA_OPENSSL: Formula["openssl@3"].opt_bin/"openssl",
      EASYRSA_PKI:     "${EASYRSA_PKI:-#{etc}/pki}"

    pkgetc.install %w[
      easyrsa3/openssl-easyrsa.cnf
      easyrsa3/x509-types
      easyrsa3/vars.example
    ]

    doc.install %w[
      ChangeLog
      COPYING.md
      KNOWN_ISSUES
      README.md
      README.quickstart.md
    ]

    doc.install Dir["doc/*"]
  end

  def caveats
    <<~EOS
      By default, keys will be created in:
        #{etc}/pki

      The configuration may be modified by editing and renaming:
        #{pkgetc}/vars.example
    EOS
  end

  test do
    ENV["EASYRSA_PKI"] = testpath/"pki"
    assert_match "'init-pki' complete; you may now create a CA or requests.",
      shell_output("#{bin}/easyrsa init-pki")
  end
end
