class Ord < Formula
  desc "Index, block explorer, and command-line wallet"
  homepage "https://ordinals.com/"
  url "https://github.com/ordinals/ord/archive/refs/tags/0.6.2.tar.gz"
  sha256 "79bcac2082d9cef4655e85048c3dba28f23a868556416352169b0541d60a20f7"
  license "CC0-1.0"
  head "https://github.com/ordinals/ord.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    expected = "error: failed to connect to Bitcoin Core RPC at 127.0.0.1:8332/wallet/ord"
    assert_match expected, shell_output("#{bin}/ord info 2>&1", 1)

    expected = "error: failed to spawn `bitcoind`"
    assert_match expected, shell_output("#{bin}/ord preview 2>&1", 1)

    assert_match "ord #{version}", shell_output("#{bin}/ord --version")
  end
end
