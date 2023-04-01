class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.25.7.tar.gz"
  sha256 "19d0196c96ce577b74afdbbdfe4b8e32bccb96ed876fabcd36ca1ea0a6e8b10b"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "658ee7fb64e9715d03b8e8f033fe241245bb32654c2884fd15bcab60b5102952"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ba3b5eba6c0ab96c32e14328ab52b8a75efd032074ee483a5b8a18f0a7bb2bdb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c3b050283f87c5f3b3403bc033f549c7d164f0ba7b9165004095a31ce9a27eaa"
    sha256 cellar: :any_skip_relocation, ventura:        "58a87500938d140a463cf91f37b2df1ef28a5de163308aab91615d18be36ac47"
    sha256 cellar: :any_skip_relocation, monterey:       "9891acac3d46df3579f01e0288d0779f041662510e49ff40a3003917c822526c"
    sha256 cellar: :any_skip_relocation, big_sur:        "001a014f1efcda4bbe5c47c2c56797661dfd0e18d8d33e81b3354575b203b0f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9329efeaa2d552a36676af4cf8714a1df61b1c6fa82f80b233a743b961a2f292"
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
