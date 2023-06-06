class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.6.0.tar.gz"
  sha256 "16fd94970e8794a30550da281d610b0822620d6b51b36a8894c44da017f7a348"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23d6e0f9f05487772c36a245911caa028777b3bbe903d250db52f5438253fa7d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4c629f5f7d2ee9f58823e63d859e2f7042a6663428590c3ce2adafeb13a961c6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3aee26f197f2f8b253e5f29d4516d0d9723f2e5ad8411a3e3c4cdab40aa386a8"
    sha256 cellar: :any_skip_relocation, ventura:        "b7332822a8ed62066e31dd0967aa8f518d2d9e4b22013b51ba6a6e2b6bc15583"
    sha256 cellar: :any_skip_relocation, monterey:       "a0d639f8b673f647134b39368151dc9653000b9c1a1da7d2bc49ae30512e066e"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2ca5e3f0a1dee46a0737e9e968eb31c4a3f7729bb989282a1ab669d6b916917"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "82c0e746a1df5fcd1a6df52d61c74e29829aa6b7c66c1b818abd63c8f706f2cf"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"Hello.js").write("console.log('123')")
    system "#{bin}/sg", "run", "-p console.log", (testpath/"Hello.js")
  end
end
