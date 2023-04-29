class Gitoxide < Formula
  desc "Idiomatic, lean, fast & safe pure Rust implementation of Git"
  homepage "https://github.com/Byron/gitoxide"
  url "https://github.com/Byron/gitoxide/archive/refs/tags/v0.25.0.tar.gz"
  sha256 "098bb18e1cae42ab7597b6b442538d3f51b57935a848ea121e20e2921d6a4693"
  license "Apache-2.0"

  # Cmake is here as only rust install wasn't enough (explained in PR)
  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  uses_from_macos "curl"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "gix-plumbing", shell_output("#{bin}/gix --version")
    system "git", "init", "test", "--quiet"
    touch "test/file.txt"
    system "git", "-C", "test", "add", "."
    system "git", "-C", "test", "commit", "--message", "initial commit", "--quiet"
    # the gix test output is to stderr so it's redirected to stderr to match
    assert_match "OK", shell_output("#{bin}/gix --repository test verify 2>&1")
    assert_match "gitoxide", shell_output("#{bin}/ein --version")
    assert_match "./test", shell_output("#{bin}/ein tool find")
  end
end
