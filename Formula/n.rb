class N < Formula
  desc "Node version management"
  homepage "https://github.com/tj/n"
  url "https://github.com/tj/n/archive/v8.0.2.tar.gz"
  sha256 "1cdc34d3a53a13a23675797dd775d562e33e64877e367df9d1afe863719de973"
  license "MIT"
  head "https://github.com/tj/n.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "54fb0e61bcd717cfd807d422985396dc3841870064205013895fa5928acb94bf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "54fb0e61bcd717cfd807d422985396dc3841870064205013895fa5928acb94bf"
    sha256 cellar: :any_skip_relocation, monterey:       "daf8a144b8334522a1a43eac4e1d82eee64667e3e54e0e3eaddb69fb02b9ced1"
    sha256 cellar: :any_skip_relocation, big_sur:        "daf8a144b8334522a1a43eac4e1d82eee64667e3e54e0e3eaddb69fb02b9ced1"
    sha256 cellar: :any_skip_relocation, catalina:       "daf8a144b8334522a1a43eac4e1d82eee64667e3e54e0e3eaddb69fb02b9ced1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54fb0e61bcd717cfd807d422985396dc3841870064205013895fa5928acb94bf"
  end

  def install
    bin.mkdir
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"n", "ls"
  end
end
