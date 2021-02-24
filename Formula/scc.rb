class Scc < Formula
  desc "Fast and accurate code counter with complexity and COCOMO estimates"
  homepage "https://github.com/boyter/scc/"
  url "https://github.com/boyter/scc/archive/v3.0.0.tar.gz"
  sha256 "01b903e27add5180f5000b649ce6e5088fa2112e080bfca1d61b1832a84a0645"
  license any_of: ["MIT", "Unlicense"]

  livecheck do
    url :homepage
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "62b0422f5870ec284d34261c83459095a958be8e6e227c61f0af534d55c1dd41"
    sha256 cellar: :any_skip_relocation, big_sur:       "93d4e567fe99406e6aa8406bef550907df0b0f668459a008ab465fd2c62c4fe2"
    sha256 cellar: :any_skip_relocation, catalina:      "648beb7662a3bd6cd47681fbabfbbe0b77ab557849c4842145c848c753ee4a53"
    sha256 cellar: :any_skip_relocation, mojave:        "82f1f701f3739a60a2e5e24e698fe0a62c0fa12ec5c0d7935c702659fe0b0eae"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      int main(void) {
        return 0;
      }
    EOS

    expected_output = <<~EOS
      Language,Lines,Code,Comments,Blanks,Complexity,Bytes
      C,4,4,0,0,0,50
    EOS

    assert_match expected_output, shell_output("#{bin}/scc -fcsv test.c")
  end
end
