class Ares < Formula
  desc "Automated decoding of encrypted text"
  homepage "https://github.com/bee-san/Ares"
  url "https://github.com/bee-san/Ares/archive/refs/tags/0.9.0.tar.gz"
  sha256 "433d50f06480547c9f6d1351a116675245a624e99eddecfe4f083442168993ca"
  license "MIT"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    input_string = "U0dWc2JHOGdabkp2YlNCSWIyMWxZbkpsZHc9PQ=="
    expected_text = "Hello from Homebrew"
    assert_includes shell_output("#{bin}/ares -d -t #{input_string}"), expected_text
  end
end
