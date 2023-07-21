class Observerward < Formula
  desc "Cross platform community web fingerprint identification tool"
  homepage "https://0x727.github.io/ObserverWard/"
  url "https://github.com/0x727/ObserverWard/archive/refs/tags/v2023.7.21.tar.gz"
  sha256 "f7a35e2269e78f274e229b229e9c3a4ffd79bc305ac737613a5dda179066dec9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "98f809f325d481065926b8dd369f651cfa8a3a01c034f5e85352cd5b77cf46cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d2df7cc4f92ddfbeb6ba47909752daf0262d5ef8e745aa906cc93380440ac433"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4297e021396eb5ccd13e1fac3dd2002baee6cd8811b52586a179ed0442623d2f"
    sha256 cellar: :any_skip_relocation, ventura:        "db6e9f4af17f1633b6c7f5c13b56910975d4be66ce3bce648e8376bb5c2bc9d4"
    sha256 cellar: :any_skip_relocation, monterey:       "89d692acfa72d72ac21f767a28a6b7f9d112f1e0d600b0bf0906ac45fbdba97e"
    sha256 cellar: :any_skip_relocation, big_sur:        "0539a6f5cccf51843714c83e7c1d1681614be11a5cd138f30080eea376fd0a8b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb1d8f2a668d69870b58cdb016513aaf52a60bc6d1a96009f876f911ae50e763"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    system bin/"observer_ward", "-u"
    assert_match "0example", shell_output("#{bin}/observer_ward -t https://www.example.com/")

    [
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"observer_ward", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
