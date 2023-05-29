class Httm < Formula
  desc "Interactive, file-level Time Machine-like tool for ZFS/btrfs"
  homepage "https://github.com/kimono-koans/httm"
  url "https://github.com/kimono-koans/httm/archive/refs/tags/0.27.1.tar.gz"
  sha256 "362311807e569ed05bca856acb33853839f45b4966d85078341c21bbc16f8cf4"
  license "MPL-2.0"
  head "https://github.com/kimono-koans/httm.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "44e6693097b57b885cf804e43c2a1a7e8f2e78d52e5b3fe4d55ed1cb869eade2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7137379309e5f4f71ef17621575f437bdd5000928d5b18b47f2ab5c17fe8befb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48cb1b1170dc1f3adb8d873109c7fdacdb03a06c6e32a448bb1321735ef5332e"
    sha256 cellar: :any_skip_relocation, ventura:        "f7d8e1f29984de49fb399213155122a2a0138df1b04d25a4dda1ceee93328cf5"
    sha256 cellar: :any_skip_relocation, monterey:       "e5f2d6463ac4d24d8c58ef661c6b76beb0b889346db3e67c727843c5910b6d5a"
    sha256 cellar: :any_skip_relocation, big_sur:        "d05e44b2918bf329cb713b6c4e0b8498ad5d10b9c8dff9bf59800d281dc21b0a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78b83e35218cf084156599da393af565b2200e8dd4ea5644e575f6bac99f7d73"
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
