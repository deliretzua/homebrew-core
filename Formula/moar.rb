class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.13.0.tar.gz"
  sha256 "65eac0d4f8a40f0198a93f0888a60a28e8466b2ee9d0437f143db5c25d5e9319"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7fa3b904ac3cbd9024786db2d6b62b15057f24905439a803affe0153b13580af"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fa3b904ac3cbd9024786db2d6b62b15057f24905439a803affe0153b13580af"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fa3b904ac3cbd9024786db2d6b62b15057f24905439a803affe0153b13580af"
    sha256 cellar: :any_skip_relocation, ventura:        "63a60475ac26b2c9a50a790611d83ae1937462960c9a0423bc8921ce657a5663"
    sha256 cellar: :any_skip_relocation, monterey:       "63a60475ac26b2c9a50a790611d83ae1937462960c9a0423bc8921ce657a5663"
    sha256 cellar: :any_skip_relocation, big_sur:        "63a60475ac26b2c9a50a790611d83ae1937462960c9a0423bc8921ce657a5663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95e5a4562ea1eabd2c55d0050af51e97f4afb69e68f905c6e2506ac162be3707"
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
