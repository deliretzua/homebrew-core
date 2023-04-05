class AdamstarkAudiofile < Formula
  desc "C++ Audio File Library by Adam Stark"
  homepage "https://github.com/adamstark/AudioFile"
  url "https://github.com/adamstark/AudioFile/archive/refs/tags/1.1.1.tar.gz"
  sha256 "664f9d5fbbf1ff6c603ae054a35224f12e9856a1d8680be567909015ccaac328"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "7d3026d78153c7dae8d493ed0265c9ef87888d2645a37a1b8b564c202fc897df"
  end

  def install
    include.install "AudioFile.h"
  end

  test do
    (testpath/"audiofile.cc").write <<~EOS
      #include "AudioFile.h"
      int main(int argc, char* *argv) {
        AudioFile<double> audioFile;
        AudioFile<double>::AudioBuffer abuf;
        return 0;
      }
    EOS

    system ENV.cxx, "-std=c++17", \
           "-o", "audiofile", \
           "audiofile.cc", \
            "-L", include.to_s
    system "./audiofile"
  end
end
