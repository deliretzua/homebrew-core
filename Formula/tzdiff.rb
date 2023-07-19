class Tzdiff < Formula
  desc "Displays Timezone differences with localtime in CLI (shell script)"
  homepage "https://github.com/belgianbeer/tzdiff"
  url "https://github.com/belgianbeer/tzdiff/archive/1.2.tar.gz"
  sha256 "6c3b6afc2bb36b001ee11c091144b8d2c451c699b69be605f2b8a4baf1f55d0a"
  license "BSD-2-Clause"

  def install
    bin.install "tzdiff"
    man1.install "tzdiff.1"
  end

  test do
    assert_match "Asia/Tokyo", shell_output("#{bin}/tzdiff -l Tokyo")
    assert_match version.to_s, shell_output("#{bin}/tzdiff -v")
  end
end
