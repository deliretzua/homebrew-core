class Fw < Formula
  desc "Workspace productivity booster"
  homepage "https://github.com/brocode/fw"
  url "https://github.com/brocode/fw/archive/refs/tags/v2.16.1.tar.gz"
  sha256 "2d77ce6673e48dd8f20ee42d8a64a0cbe648d51b837cb930b69c3707718659c2"
  license "WTFPL"

  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "zlib"

  resource "fw.1" do
    url "https://github.com/brocode/fw/releases/download/v2.16.1/fw.1"
    sha256 "b19e2ccb837e4210d7ee8bb7a33b7c967a5734e52c6d050cc716490cac061470"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
    man1.install resource("fw.1")
  end

  test do
    assert_match "Synchronizing everything", shell_output("#{bin}/fw sync 2>&1", 1)
    assert_match "fw #{version}", shell_output("#{bin}/fw --version")
  end
end
