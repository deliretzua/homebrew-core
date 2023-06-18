class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.24.10.tar.gz"
  sha256 "56aa9dbf85dc14b2d6ea6e0922fd0464f45af09e2aa26641c6db84d61e2de543"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3ecf4966bcff0d7a785326f8fe85168eb04c6b6067b97c1e1559ecc32182f421"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d123d81e659df9c992b583ff4c7bacc54200adbb3a270f635d8c857a918e0d3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63f881effdbbfb15892c362c2f1a2ad31b7f23ee3ccf81ed2dfae9c72f6c7d01"
    sha256 cellar: :any_skip_relocation, ventura:        "20a84cb51f63a46ccc9690df708114bb036677fabd222f8d3e04fda8e687e5b3"
    sha256 cellar: :any_skip_relocation, monterey:       "fcc61937e3dce422ae09d05196741a8b376431ed00d26599d87cae853a22a1cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f63afa294fd548429ccd5b3e25c907348cfeae21a2dd200ea3a0387fd10435a3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d63c11ca314240c51f31f66765f8daa1dcfd8ba9a7feb01de8eff9ec21096da1"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2@1.5"
  depends_on "openssl@1.1"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
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
    # Show that we can use a different toolchain than the one provided by the `rust` formula.
    # https://github.com/Homebrew/homebrew-core/pull/134074#pullrequestreview-1484979359
    ENV["RUSTUP_INIT_SKIP_PATH_CHECK"] = "yes"
    system "#{Formula["rustup-init"].bin}/rustup-init", "-y", "--no-modify-path"
    ENV.prepend_path "PATH", HOMEBREW_CACHE/"cargo_cache/bin"
    system "rustup", "default", "beta"

    system "cargo", "new", "hello_world", "--bin"
    cd "hello_world" do
      assert_match "tag = true", shell_output("cargo release config 2>&1").chomp
    end

    [
      Formula["libgit2@1.5"].opt_lib/shared_library("libgit2"),
      Formula["openssl@1.1"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
