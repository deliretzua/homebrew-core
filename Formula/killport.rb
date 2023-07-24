class Killport < Formula
  desc "Command-line tool to kill processes listening on a specific port"
  homepage "https://github.com/jkfran/killport"
  url "https://github.com/jkfran/killport/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "3ff4fd79006f42b2ed89ff26fc87a36d505880de6b208686a4699ab9434a0811"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    port = free_port
    output = shell_output("#{bin}/killport --signal sigkill #{port}")
    assert_match "No processes found using port #{port}", output
  end
end
