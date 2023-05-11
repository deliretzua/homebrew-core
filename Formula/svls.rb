class Svls < Formula
  desc "SystemVerilog language server"
  homepage "https://github.com/dalance/svls"
  url "https://github.com/dalance/svls/archive/refs/tags/v0.2.9.tar.gz"
  sha256 "627887f4b105a024c31cd09c9baee9389e70652e85fa8231e5c52079db8dfeb3"
  license "MIT"
  head "https://github.com/dalance/svls.git", branch: "master"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = /^Content-Length: \d+\s*$/
    assert_match output, pipe_output(bin/"svls", "\r\n")
  end
end
