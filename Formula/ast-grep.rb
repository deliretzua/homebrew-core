class AstGrep < Formula
  desc "Code searching, linting, rewriting"
  homepage "https://github.com/ast-grep/ast-grep"
  url "https://github.com/ast-grep/ast-grep/archive/refs/tags/0.6.1.tar.gz"
  sha256 "02d168ab83d95e6ccc1e1c5a637ceeffb0b0f91e8bfe4fc30105a94936edceaf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "da41965ffdc57f671ec4d72b148fe226dddfaaa39018c217107ce4d8b7def286"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09c444d475b4a610e1e28bcfd9c6c21dd82496847b73d58fe3735a7953dd882a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a6edec825a723dff8d3a0421c338a650543028021f923c9662cc425c3159064"
    sha256 cellar: :any_skip_relocation, ventura:        "a9a8571b9e3a81b91c03cd831195547fd2d0e41ccc5faff1cf3b104df48b6846"
    sha256 cellar: :any_skip_relocation, monterey:       "073c51c889a1a88f7a1c969a006a6b577dc87cfd3e6ec02ad3337f67c669174d"
    sha256 cellar: :any_skip_relocation, big_sur:        "3d36b03616fc727d1c2029b929e35844cf8321f3417a2da36841ab8e0dc9f09d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "919927edd9ad6b4181c26a4cc62a6ef5254b071e6bdf22e64038c85db3b7077b"
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
