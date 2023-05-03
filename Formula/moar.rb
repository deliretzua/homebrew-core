class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.14.0.tar.gz"
  sha256 "93287d8b7fc287b6cbc1c2e830a3df618ec31e17dc6eaf5ea5fb72d75e3bc7e8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4606f814adca88c0441d94d1be8c4dc5ce0877b2aacec7811f30b054126e12b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a4606f814adca88c0441d94d1be8c4dc5ce0877b2aacec7811f30b054126e12b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a4606f814adca88c0441d94d1be8c4dc5ce0877b2aacec7811f30b054126e12b"
    sha256 cellar: :any_skip_relocation, ventura:        "8c0ea8307a6d7471ad7c5e0ed2d1be7c94cf48faa6c8b0371238317eda76c014"
    sha256 cellar: :any_skip_relocation, monterey:       "8c0ea8307a6d7471ad7c5e0ed2d1be7c94cf48faa6c8b0371238317eda76c014"
    sha256 cellar: :any_skip_relocation, big_sur:        "8c0ea8307a6d7471ad7c5e0ed2d1be7c94cf48faa6c8b0371238317eda76c014"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f66479a4a358a572c29565048248003e8c32345dd0a08d706a98d8663986eb08"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.versionString=v#{version}"
    system "go", "build", *std_go_args(ldflags: ldflags)
    man1.install "moar.1"
  end

  test do
    # Test piping text through moar
    (testpath/"test.txt").write <<~EOS
      tyre kicking
    EOS
    assert_equal "tyre kicking", shell_output("#{bin}/moar test.txt").strip
  end
end
