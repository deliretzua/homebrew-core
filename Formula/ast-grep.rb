class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.6.4.tar.gz"
  sha256 "7074f63968eb2bf26ab3979ff0d45e45fab196aaaa98dc4b6cd0d11cdeaa30ba"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "12e9ad08d12263b5ecf42f86159329b5096ec0e37a452722ba9cbac08dc1ce5a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c6b7b594c462af64bdae00a3e24894a5b2ced304048917256e743ebb9526b943"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "20c6bf1e55fe6cdb37bd40ddc302aad489ff3c143c84ef49462d41b21bec0c58"
    sha256 cellar: :any_skip_relocation, ventura:        "5d252b19aa6dff7c69d042bb0ec00cf2ac4eefe0d9c32d88c0be8decddb0fa98"
    sha256 cellar: :any_skip_relocation, monterey:       "8092aae6585513d44afcb1398fb537588698e9561b6fdcb9ced8229bdc3ffe1a"
    sha256 cellar: :any_skip_relocation, big_sur:        "e151f1b6150d0426c41d25ad4253fc94f22cd64f38e92400ff28df5bf9f64bd9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a987f8b5e19b1459401c3fa698d19eed55de14bb293a01e4d24d2e9444d1cfe"
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
