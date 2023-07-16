class BatsCore < Formula
  desc "Bash Automated Testing System"
  homepage "https://github.com/bats-core/bats-core"
  url "https://github.com/bats-core/bats-core/archive/v1.10.0.tar.gz"
  sha256 "a1a9f7875aa4b6a9480ca384d5865f1ccf1b0b1faead6b47aa47d79709a5c5fd"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "71fce4432c97bf46f4ae681afbf2958175b25bb6297a1b11ee10d553d6eddc93"
  end

  depends_on "coreutils"

  uses_from_macos "bc" => :test

  def install
    system "./install.sh", prefix
  end

  test do
    (testpath/"test.sh").write <<~EOS
      @test "addition using bc" {
        result="$(echo 2+2 | bc)"
        [ "$result" -eq 4 ]
      }
    EOS
    assert_match "addition", shell_output("#{bin}/bats test.sh")
  end
end
