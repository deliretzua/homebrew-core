class Prqlc < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/PRQL/prql/archive/refs/tags/0.8.1.tar.gz"
  sha256 "06650d5a21b1cb3eabae05d129ceaaaecd9eb7788edfbd3e63947e83279ca9c3"
  license "Apache-2.0"
  head "https://github.com/prql/prql.git", branch: "main"

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prql-compiler/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
