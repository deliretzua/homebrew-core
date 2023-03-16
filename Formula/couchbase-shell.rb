class CouchbaseShell < Formula
  desc "Modern and fun shell for Couchbase Server and Capella"
  homepage "https://couchbase.sh"
  url "https://github.com/couchbaselabs/couchbase-shell/archive/v0.75.2.tar.gz"
  sha256 "72d99bf1de8a050137b080825299eca01d2aa4fb5e10bf75927008314e88b783"
  license "Apache-2.0"
  head "https://github.com/couchbaselabs/couchbase-shell.git", branch: "main"

  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "libx11"
    depends_on "libxcb"
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "homebrew_test", shell_output("#{bin}/cbsh -c '{ foo: 1, bar: homebrew_test} | get bar'")
  end
end
