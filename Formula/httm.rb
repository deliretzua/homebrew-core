class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.25.4.tar.gz"
  sha256 "db5a793f7d3f2c9ec0596caf6f9e3b357d4db8a6595b5fc22f521506ca365dfc"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3e75e0e5a1f527dd6c9664f20d0bf415b3b679c47b775a3ca6b303a3d2d06aca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3a76ee8e8a96d926d0adf2d981e7ea36cde0ec1385b48220e199d25128123164"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2bf61948558d09e00c02bae38103440d3313294cdba6eec14eb3644aa5f75378"
    sha256 cellar: :any_skip_relocation, ventura:        "885255653f610955ca5ea6a30e0cd8143d4fa5f17fb75bed44d2475eafd6d0ed"
    sha256 cellar: :any_skip_relocation, monterey:       "794c8b3870ea3263e56e73c8cf3d70ecf7334ac100bb6cf9b441c054dda33ef4"
    sha256 cellar: :any_skip_relocation, big_sur:        "c578ab9af95be99e3dd571f86382ef50cbd06aa0bf5e8384febd11bb60d0729c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d52354d105a8bb7d04c0d8aaf230529ee875612b437f20ce1825a64218c73c1"
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
