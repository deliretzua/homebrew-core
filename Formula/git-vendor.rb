class GitVendor < Formula
  desc "Command for managing git vendored dependencies"
  homepage "https://brettlangdon.github.io/git-vendor"
  url "https://github.com/brettlangdon/git-vendor/archive/v1.2.0.tar.gz"
  sha256 "d464f048769dfe7125d6c2453ec3b19b53920d9ebc80d0b28bab05011481ce89"
  license "MIT"
  head "https://github.com/brettlangdon/git-vendor.git"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4a32c52d725602c25e460a58d24f99029753aab5a215530bc0717968841bf8f3"
  end

  # Fix issue with /bin/sh builtin echo not supporting -n option
  # Remove in the next release
  patch do
    url "https://github.com/brettlangdon/git-vendor/commit/c58c212f24fe54b0c77860da5185fc2bf3b77986.patch?full_index=1"
    sha256 "5393c3a03856014ef1609ebca52006c23ead1f72c4737740704642492467f7b5"
  end

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "git", "init"
    system "git", "config", "user.email", "author@example.com"
    system "git", "config", "user.name", "Au Thor"
    system "git", "add", "."
    system "git", "commit", "-m", "Initial commit"
    system "git", "vendor", "add", "git-vendor", "https://github.com/brettlangdon/git-vendor", "v1.1.0"
    assert_match "git-vendor@v1.1.0", shell_output("git vendor list")
  end
end
