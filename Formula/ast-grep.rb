class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.9.1.tar.gz"
  sha256 "23d0a29846ba19ee06b51b31acba26d2693e6ee7b08d55814464df1fcc0b2dc4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "1ea7ae88c5d05c81e9d29869cd63fac73d3faecd191b376a446e9147dd96c407"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8be1c2cad293157fedb2fd8516788dbf63cd47f64dfc74a70c7ab1c99e49a1a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3e35bd9cd073598666d980902ef55db0b02f2f642d5570bf96af65b83e1d1552"
    sha256 cellar: :any_skip_relocation, ventura:        "f7701408e9cb1c409e94e1cca04aa90e9c08f6a222d4a6743c580666fb8125b7"
    sha256 cellar: :any_skip_relocation, monterey:       "a948f6d916280c42eaabed74777d71d733a5dad9215036faee255adede748243"
    sha256 cellar: :any_skip_relocation, big_sur:        "ad7943cb8b434ed84241364d86989807c58795a7e506f589c84e5b42eaef1edc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9dd4065b7f6c26d220af0a5995185d21f6376189ce48adfe3813d6ee775be93c"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "crates/cli")
  end

  test do
    (testpath/"hi.js").write("console.log('it is me')")
    system "#{bin}/sg", "run", "-l", "js", "-p console.log", (testpath/"hi.js")
  end
end
