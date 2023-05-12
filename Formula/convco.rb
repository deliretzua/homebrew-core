class Convco < Formula
  desc "Conventional commits, changelog, versioning, validation"
  homepage "https://convco.github.io"
  url "https://github.com/convco/convco/archive/refs/tags/v0.4.0.tar.gz"
  sha256 "88c92b175163c8847da7dd201d32106c51ff85e2c992c2a3ff67e29ecbe57abb"
  license "MIT"
  head "https://github.com/convco/convco.git", branch: "master"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  depends_on "libgit2@1.5"

  def install
    # Link with a shared library instead of building a vendored version
    inreplace "Cargo.toml", ', features = [ "zlib-ng-compat" ]', ""
    system "cargo", "install", *std_cargo_args

    bash_completion.install "target/completions/convco.bash" => "convco"
    zsh_completion.install  "target/completions/_convco" => "_convco"
    fish_completion.install "target/completions/convco.fish" => "convco.fish"
  end

  test do
    system "git", "init"
    system "git", "commit", "--allow-empty", "-m", "invalid"
    assert_match(/FAIL  \w+  first line doesn't match `<type>\[optional scope\]: <description>`  invalid\n/,
      shell_output("#{bin}/convco check", 1).lines.first)

    # Verify that we are using the libgit2 library
    linkage_with_libgit2 = (bin/"convco").dynamically_linked_libraries.any? do |dll|
      next false unless dll.start_with?(HOMEBREW_PREFIX.to_s)

      File.realpath(dll) == (Formula["libgit2@1.5"].opt_lib/shared_library("libgit2")).realpath.to_s
    end
    assert linkage_with_libgit2, "No linkage with libgit2! Cargo is likely using a vendored version."
  end
end
