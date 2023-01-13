class Tz < Formula
  desc "CLI time zone visualizer"
  homepage "https://github.com/oz/tz"
  url "https://github.com/oz/tz/archive/refs/tags/v0.6.2.tar.gz"
  sha256 "f4dc3ae2089701947cbdba37f9684708d5fd63e362b1355469105860b08b356b"
  license "GPL-3.0-or-later"
  head "https://github.com/oz/tz.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c961532b2ab2604a9d659ff39e7160821e59a585d12b6653b6f58754c2863557"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c961532b2ab2604a9d659ff39e7160821e59a585d12b6653b6f58754c2863557"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c961532b2ab2604a9d659ff39e7160821e59a585d12b6653b6f58754c2863557"
    sha256 cellar: :any_skip_relocation, ventura:        "80c69c3de5137e46284305295b9154a65597ee5fc874786960cbe2c35252668b"
    sha256 cellar: :any_skip_relocation, monterey:       "80c69c3de5137e46284305295b9154a65597ee5fc874786960cbe2c35252668b"
    sha256 cellar: :any_skip_relocation, big_sur:        "80c69c3de5137e46284305295b9154a65597ee5fc874786960cbe2c35252668b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67f8546f0d90e65fa86eb500f0efaed4d1a7b3dc774baca0fd1a0f5e842b44db"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
  end

  test do
    assert_match "US/Eastern", shell_output("#{bin}/tz --list")

    assert_match version.to_s, shell_output("#{bin}/tz -v")
  end
end
