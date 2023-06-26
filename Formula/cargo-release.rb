class CargoRelease < Formula
  desc "Cargo subcommand `release`: everything about releasing a rust crate"
  homepage "https://github.com/crate-ci/cargo-release"
  url "https://github.com/crate-ci/cargo-release/archive/refs/tags/v0.24.11.tar.gz"
  sha256 "cbbc04f7faadd2202b36401f3ffafc8836fb176062d428d2af195c02a2f9bd58"
  license any_of: ["Apache-2.0", "MIT"]
  head "https://github.com/crate-ci/cargo-release.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "1b9a675c75921698ff1d69952f99668f34ef14d3a3dd0e0f5244e933dbc04794"
    sha256 cellar: :any,                 arm64_monterey: "bab0037a75a88c9e8e3ce32e70ab935f0bf4cb88b7ab4b30fb913c7d4c2d919b"
    sha256 cellar: :any,                 arm64_big_sur:  "805ac31138fc2e1a79e8ab622c1dbed1ca9746d43dedf24b4696c74ee7b0959b"
    sha256 cellar: :any,                 ventura:        "40804ff307bffb75cefe90cf6403e64b51843e793af994db46d14dddeb9d05dd"
    sha256 cellar: :any,                 monterey:       "3f272287b257fc2f4ceb74f424ab2c67ad95d3284705e48b3c9bd17876312d6a"
    sha256 cellar: :any,                 big_sur:        "01423769e36908577000246d36a9873043ccdefba68e3f728f5687d79ee4190e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2477a2aaa2a317f04d02cc70ab20ba69a3bf2c0146fcdc192d11e918247a9a4e"
  end

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "rustup-init" => :test
  depends_on "libgit2"
  depends_on "openssl@3"

  def install
    ENV["LIBGIT2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["LIBSSH2_SYS_USE_PKG_CONFIG"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
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
      Formula["libgit2"].opt_lib/shared_library("libgit2"),
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
    ].each do |library|
      assert check_binary_linkage(bin/"cargo-release", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
