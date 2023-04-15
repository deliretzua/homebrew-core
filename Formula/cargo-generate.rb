class CargoGenerate < Formula
  desc "Use pre-existing git repositories as templates"
  homepage "https://github.com/cargo-generate/cargo-generate"
  url "https://github.com/cargo-generate/cargo-generate/archive/refs/tags/v0.18.3.tar.gz"
  sha256 "e44e021dbc83cc862e4f52fce76ed6cfab0cf08d74505fe177bec048f981ac9b"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/cargo-generate/cargo-generate.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2"
  depends_on "libssh2"
  depends_on "openssl@1.1"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    # Ensure the correct `openssl` will be picked up.
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", "--no-default-features", *std_cargo_args
  end

  def check_binary_linkage(binary, library)
    binary.dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == File.realpath(library)
    end
  end

  test do
    assert_match "No favorites defined", shell_output("#{bin}/cargo-generate gen --list-favorites")

    system bin/"cargo-generate", "gen", "--git", "https://github.com/ashleygwilliams/wasm-pack-template",
                                 "--name", "brewtest"
    assert_predicate testpath/"brewtest", :exist?
    assert_match "brewtest", (testpath/"brewtest/Cargo.toml").read

    linked_libraries = [
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["libssh2"].opt_lib/shared_library("libssh2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
    ]
    linked_libraries << (Formula["openssl@1.1"].opt_lib/shared_library("libcrypto")) if OS.mac?
    linked_libraries.each do |library|
      assert check_binary_linkage(bin/"cargo-generate", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
