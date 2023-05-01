class Dzr < Formula
  desc "Command-line Deezer.com player"
  homepage "https://github.com/yne/dzr"
  url "https://github.com/yne/dzr/archive/refs/tags/230513.tar.gz"
  sha256 "efde6ed1e291adff29b7d511c3c2dd8cdc03c6a2d19558ae07d467c037ccb6a0"
  license "Unlicense"
  head "https://github.com/yne/dzr.git", branch: "master"

  depends_on "dialog"
  depends_on "jq"
  depends_on "mpv"
  depends_on "openssl@1.1" # to match curl one
  uses_from_macos "curl"

  def install
    bin.install "dzr", "dzr-url", "dzr-dec", "dzr-srt", "dzr-id3"
  end

  test do
    ENV.delete "DZR_CBC"
    assert_equal "3ad58d9232a3745ad9308b0669c83b6f7e8dba4d",
                 Digest::SHA1.hexdigest(shell_output("#{bin}/dzr !").chomp)
  end
end
