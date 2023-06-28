class Alass < Formula
  desc "Automatic Language-Agnostic Subtitle Synchronization"
  homepage "https://github.com/kaegi/alass"
  url "https://github.com/kaegi/alass/archive/refs/tags/v2.0.0.tar.gz"
  sha256 "ce88f92c7a427b623edcabb1b64e80be70cca2777f3da4b96702820a6cdf1e26"
  license "GPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args(path: "alass-cli")
  end

  test do
    (testpath/"reference.srt").write <<~EOS
      1
      00:00:00,000 --> 00:00:01,000
      This is the first subtitle.
    EOS

    (testpath/"incorrect.srt").write <<~EOS
      1
      00:00:01,000 --> 00:00:02,000
      This is the first subtitle.
    EOS

    output = shell_output("#{bin}/alass-cli reference.srt incorrect.srt output.srt").strip
    assert_match "shifted block of 1 subtitles with length 0:00:00.000 by -0:00:01.000", output
  end
end
