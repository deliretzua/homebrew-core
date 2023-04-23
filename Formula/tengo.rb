class Tengo < Formula
  desc "Fast script language for Go"
  homepage "https://tengolang.com"
  url "https://github.com/d5/tengo/archive/v2.15.0.tar.gz"
  sha256 "99c929b8bbe3a7aeac455d8a546516d862dedf68b5581521d5ae9f59595ab0df"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cce6c41aadf51e0ce88f4ef2f28a28a69a27eaba8d329898c56b790270817b52"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cce6c41aadf51e0ce88f4ef2f28a28a69a27eaba8d329898c56b790270817b52"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "cce6c41aadf51e0ce88f4ef2f28a28a69a27eaba8d329898c56b790270817b52"
    sha256 cellar: :any_skip_relocation, ventura:        "a6e49afb6897ec5d5f866bcaa84ee0225a65b27b18bba46a7cfd7493995503f5"
    sha256 cellar: :any_skip_relocation, monterey:       "a6e49afb6897ec5d5f866bcaa84ee0225a65b27b18bba46a7cfd7493995503f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6e49afb6897ec5d5f866bcaa84ee0225a65b27b18bba46a7cfd7493995503f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "51425e7a5e94e81c5022a47a7ce7fcd17f65bcb0bb8000007557570cc6db6203"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/tengo"
  end

  test do
    (testpath/"main.tengo").write <<~EOS
      fmt := import("fmt")

      each := func(seq, fn) {
          for x in seq { fn(x) }
      }

      sum := func(init, seq) {
          each(seq, func(x) { init += x })
          return init
      }

      fmt.println(sum(0, [1, 2, 3]))   // "6"
      fmt.println(sum("", [1, 2, 3]))  // "123"
    EOS
    assert_equal shell_output("#{bin}/tengo #{testpath}/main.tengo"), "6\n123\n"
  end
end
