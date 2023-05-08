class Wally < Formula
  desc "Modern package manager for Roblox projects inspired by Cargo"
  homepage "https://github.com/UpliftGames/wally"
  url "https://github.com/UpliftGames/wally/archive/refs/tags/v0.3.1.tar.gz"
  sha256 "c9b8bcdbfc906848fac5a49d69f54d3b2b4830b23dda7cd47190c5624c2bf04c"
  license "MPL-2.0"
  head "https://github.com/UpliftGames/wally.git", branch: "main"

  depends_on "pkg-config" => :build
  depends_on "rust" => :build
  # TODO: move to openssl@3 on `version` bump
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    odie "Check for new OpenSSL version" if version > "0.3.1"
    ENV["OPENSSL_NO_VENDOR"] = "1"
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"wally.toml").write <<~EOS
      [package]
      name = "test/test"
      version = "0.1.0"
      license = "MIT"
      realm = "server"
      registry = "https://github.com/UpliftGames/wally-index"
      [dependencies]
    EOS

    system bin/"wally", "install"
    assert_predicate testpath/"wally.lock", :exist?
  end
end
