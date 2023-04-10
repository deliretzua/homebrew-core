class Gofumpt < Formula
  desc "Stricter gofmt"
  homepage "https://github.com/mvdan/gofumpt"
  url "https://github.com/mvdan/gofumpt/archive/v0.5.0.tar.gz"
  sha256 "e27f04b8b5619747ebfb955699d6895c1e4c7c5e4478507ca4e2d8b658b8b51c"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8ac2f60dfe7a39ba22310052bd021d6a9bdf82fd73487c1655427718ee755fba"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ac2f60dfe7a39ba22310052bd021d6a9bdf82fd73487c1655427718ee755fba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ac2f60dfe7a39ba22310052bd021d6a9bdf82fd73487c1655427718ee755fba"
    sha256 cellar: :any_skip_relocation, ventura:        "55dae3df15d489825e9218c2e6c37afa71490bf74415976549d1998b9b7d9be9"
    sha256 cellar: :any_skip_relocation, monterey:       "55dae3df15d489825e9218c2e6c37afa71490bf74415976549d1998b9b7d9be9"
    sha256 cellar: :any_skip_relocation, big_sur:        "55dae3df15d489825e9218c2e6c37afa71490bf74415976549d1998b9b7d9be9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fc732483cca12c6bdf11a9a5d7f9435a1093511ac8f212fe7fed45bfcc7e8a35"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X mvdan.cc/gofumpt/internal/version.version=#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  test do
    (testpath/"test.go").write <<~EOS
      package foo

      func foo() {
        println("bar")

      }
    EOS

    (testpath/"expected.go").write <<~EOS
      package foo

      func foo() {
      	println("bar")
      }
    EOS

    assert_match shell_output("#{bin}/gofumpt test.go"), (testpath/"expected.go").read
  end
end
