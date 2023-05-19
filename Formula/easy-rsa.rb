class EasyRsa < Formula
  desc "CLI utility to build and manage a PKI CA"
  homepage "https://github.com/OpenVPN/easy-rsa"
  url "https://github.com/OpenVPN/easy-rsa/archive/v3.1.3.tar.gz"
  sha256 "f2967aa598cb603dd20791002e767d0ce58e300b04c9cff1b6d6b14fedae6a80"
  license "GPL-2.0-only"
  head "https://github.com/OpenVPN/easy-rsa.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "dbac3fea20b3ddfb53762670eea6091267b8a6e7473e39fef5af14f80ff0a5dc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dbac3fea20b3ddfb53762670eea6091267b8a6e7473e39fef5af14f80ff0a5dc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "dbac3fea20b3ddfb53762670eea6091267b8a6e7473e39fef5af14f80ff0a5dc"
    sha256 cellar: :any_skip_relocation, ventura:        "58c1d07bbf1f9e3fe3ca37cc7d481df76ea23101a93df44b0957638ba23ba1dc"
    sha256 cellar: :any_skip_relocation, monterey:       "58c1d07bbf1f9e3fe3ca37cc7d481df76ea23101a93df44b0957638ba23ba1dc"
    sha256 cellar: :any_skip_relocation, big_sur:        "58c1d07bbf1f9e3fe3ca37cc7d481df76ea23101a93df44b0957638ba23ba1dc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dbac3fea20b3ddfb53762670eea6091267b8a6e7473e39fef5af14f80ff0a5dc"
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
