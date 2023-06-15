class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.28.6.tar.gz"
  sha256 "55476859ae5d2683d735718f958e734d7f2026e4fc145c61a68571a838c701fc"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3addea3e4d88084b5a6786ba8bfe3800c7535800fb80cff3d3ffa48976caaccc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9b7ee21087cb0b70445ae9e093e7e387b663fcebb3c6ea35f8aded2fc149bd17"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9ac44e9c20b375b706bd363f88007f706d2c2934cde995c0068b3a3534d6dcff"
    sha256 cellar: :any_skip_relocation, ventura:        "a41ca73cd3f5905dffcbb8faa264376a7717be5bd6deab7aa81010386a878ae7"
    sha256 cellar: :any_skip_relocation, monterey:       "dee21414eda0ef03370a9cd50c662f07a12a04897d753563ef5bd503dfd97564"
    sha256 cellar: :any_skip_relocation, big_sur:        "cbdbcc351cf3c0ccf44903a410a7791b55cdcafa36428e50493d4fd37442ac70"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "24259f539667a91eed74cdf38ee577e11380713664cae17cc1d23cda5fcb9021"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
    man1.install "httm.1"
  end

  test do
    touch testpath/"foo"
    assert_equal "Error: httm could not find any valid datasets on the system.",
      shell_output("#{bin}/httm #{testpath}/foo 2>&1", 1).strip
    assert_equal "httm #{version}", shell_output("#{bin}/httm --version").strip
  end
end
