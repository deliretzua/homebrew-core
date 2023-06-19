class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.29.3.tar.gz"
  sha256 "3c6d185bf0ead92c20118a19f2db6133628925238e3d04bc253af3b71dc3f66a"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "59efce29f5ff83850d4dceec32313a693958dcb667b5f0541addbdc55de2d9b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "839f567d5abd0237b14c9ed8fdd4adb6a0790c41deb4b58c0f6ceee25b8add1e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ec32c791ae8fc8cfc650e03aceba47c3c54cf67d0780952c998556a3b30bd55"
    sha256 cellar: :any_skip_relocation, ventura:        "ee752f5b15da360beb45a12deed531ad9d42f8648107901685e1611158ef2458"
    sha256 cellar: :any_skip_relocation, monterey:       "9060ae50468d817924db55c331bcb0b79a11a194b094c8f7642088c7a8169473"
    sha256 cellar: :any_skip_relocation, big_sur:        "88580059f020267fab98b08cbec92caf274d118760e395d13070c52c550c01c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d3e3a9eba70ba452ee51c981b9869bdc7bcea886843d6cab3979280a0b740e10"
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
