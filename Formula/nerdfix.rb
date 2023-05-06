class Nerdfix < Formula
  desc "Find/fix obsolete Nerd Font icons"
  homepage "https://github.com/loichyan/nerdfix"
  url "https://github.com/loichyan/nerdfix/archive/refs/tags/v0.2.3.tar.gz"
  sha256 "0a4587caaa2d9654ef41e48612267343c5f018387f3f36564688263114629cad"
  license any_of: ["MIT", "Apache-2.0"]

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    touch "test.txt"
    system bin/"nerdfix", "check", "test.txt"
  end
end
