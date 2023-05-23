class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.26.6.tar.gz"
  sha256 "13eb514339e888c0cfd5e56435a2c5662ef93c089a134de671b9b6581b4e78f1"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa88918525a12675db91b30909a9a5f8121f6de802a73ef77d22906bddb3f832"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0732f7c94a99dad1384f4a5696607991ecfd978baf20c2805b141e2cb993d766"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8e2100e3849a0e1bd30ea2bfb425661fad2a902ba62ba925d89653a1149f6ee2"
    sha256 cellar: :any_skip_relocation, ventura:        "7837ad7620cec2d1c19f2f615788a00b4d1469b1a9e68954621bbbdd2336ce39"
    sha256 cellar: :any_skip_relocation, monterey:       "572fc03b1b46d6bd08d1e219f0db59dcc84c1e217c0042e9320d72fcf846dd1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "184b13460e73f3d63062da5f2243ed4bd209cf4691456abacbf284c0e3db371d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bcb320dd90488cc2ca54bb17838acb6e80e3321a424ce3d9793960efb9f1495b"
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
