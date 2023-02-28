class Moar < Formula
  desc "Nice to use pager for humans"
  homepage "https://github.com/walles/moar"
  url "https://github.com/walles/moar/archive/refs/tags/v1.12.0.tar.gz"
  sha256 "9b5cb4abab746e51c632648b50634a6f4255b709938ca8be240bff49e73bdc0b"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8019185514964e3baeeec09a4bb2d87f43f524c4a2025f2f4695c5995e804eb4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8019185514964e3baeeec09a4bb2d87f43f524c4a2025f2f4695c5995e804eb4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8019185514964e3baeeec09a4bb2d87f43f524c4a2025f2f4695c5995e804eb4"
    sha256 cellar: :any_skip_relocation, ventura:        "22f442ac122ee2af683e6a68d4a98bb3be58247696d9c637aea488ce6b3a5b98"
    sha256 cellar: :any_skip_relocation, monterey:       "22f442ac122ee2af683e6a68d4a98bb3be58247696d9c637aea488ce6b3a5b98"
    sha256 cellar: :any_skip_relocation, big_sur:        "22f442ac122ee2af683e6a68d4a98bb3be58247696d9c637aea488ce6b3a5b98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "faccdcb98a9d45ce8539a6889405cd8bb030e5e553ff98ac5baa8acd57df2a4d"
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
