class Hex < Formula
  desc "Futuristic take on hexdump"
  homepage "https://github.com/sitkevij/hex"
  url "https://github.com/sitkevij/hex/archive/refs/tags/v0.4.2.tar.gz"
  sha256 "a7cc1ece337fc19e77fbbbca145001bc5d447bde4118eb6de2c99407eb1a3b74"
  license "MIT"
  head "https://github.com/sitkevij/hex.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    (testpath/"tiny.txt").write("il")
    output = shell_output("#{bin}/hx tiny.txt")
    assert_match "0x000000: 0x69 0x6c", output

    output = shell_output("#{bin}/hx -ar -c8 tiny.txt")
    expected = <<~EOS
      let ARRAY: [u8; 2] = [
          0x69, 0x6c
      ];
    EOS
    assert_equal expected, output

    assert_match "hx #{version}", shell_output("#{bin}/hx --version")
  end
end
