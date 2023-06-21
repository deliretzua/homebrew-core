class Sh4d0wup < Formula
  desc "Signing-key abuse and update exploitation framework"
  homepage "https://github.com/kpcyrd/sh4d0wup"
  url "https://github.com/kpcyrd/sh4d0wup/archive/v0.9.0.tar.gz"
  sha256 "ec6aa007417e76338bc903d969e88f038ba982eb603f227f85caea5b8ad715c3"
  license "GPL-3.0-or-later"

  depends_on "llvm@15" => :build # for libclang
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "pgpdump" => :test
  depends_on "nettle"
  depends_on "openssl@3"
  depends_on "pcsc-lite"
  depends_on "zstd"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"sh4d0wup", "completions")
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    output = shell_output("#{bin}/sh4d0wup keygen tls example.com | openssl x509 -text -noout")
    assert_match("DNS:example.com", output)

    output = shell_output("#{bin}/sh4d0wup keygen pgp | pgpdump")
    assert_match("New: Public Key Packet", output)

    output = shell_output("#{bin}/sh4d0wup keygen ssh --type=ed25519 --bits=256 | ssh-keygen -lf -")
    assert_match("no comment (ED25519)", output)

    output = shell_output("#{bin}/sh4d0wup keygen openssl --secp256k1 | openssl ec -text -noout")
    assert_match("ASN1 OID: secp256k1", output)

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert check_binary_linkage(bin/"sh4d0wup", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
