class Typst < Formula
  desc "Markup-based typesetting system"
  homepage "https://github.com/typst/typst"
  url "https://github.com/typst/typst/archive/refs/tags/v23-03-28.tar.gz"
  version "23-03-28"
  sha256 "494b0438940a21370d31d44e090e1a6b1b3acabc8b9c4c181455f86441d5cab7"
  license "Apache-2.0"
  head "https://github.com/typst/typst.git", branch: "main"

  depends_on "rust" => :build

  def install
    ENV["TYPST_VERSION"] = version.to_s
    system "cargo", "install", *std_cargo_args(path: "cli")
  end

  test do
    (testpath/"Hello.typ").write("Hello World!")
    system bin/"typst", testpath/"Hello.typ"

    assert_match version.to_s, shell_output("#{bin}/typst --version")
  end
end
